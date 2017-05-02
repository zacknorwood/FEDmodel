"""Data unification script for FED metering data
Contains a single class, 'BColl', which is basically a dict with a few attached 
methods for loading, formatting and outputting building data.
See its methods for details."""

"""Note to future programmers: Basing BColl directly off of a dict instead of 
creating a custom class and attaching dicts as attributes WAS A REALLY BAD
IDEA. This makes it really cumbersome to print variations (subsets etc) of 
all data. Hopefully what's here now will suffice for this analysis, however if 
more functionality is to be attached to this class a complete rework might be 
advisable."""

## Can always push the collected data as a single big JSON and load into R for analysis if needed

import re, json, os, glob, datetime, traceback, copy
import numpy as np

### Work towards: Scatter of energy-index.
### Scatter tid-på-dygn - värmelast
### -> + minus linjärmodell

# Module-wide definitions
oneHour = datetime.timedelta(seconds=3600)

# Step 1: create list of all .txt files

class BColl(dict):
    """Dict-like object with a few extra functions for parsing, formatting and 
    handling meter-data
    """
    def __init__(self, parse=False, source=None, quickRun = False):
        """Initialisation. Will by default create and attach a list of all 
        text files in ./data upon being called. Use parse=True to immediately
        parse all files and add interpolated timeseriess. 
        Use source = 'fileName.json' to instead load data from a json
        use quickRun= True to parse all data, then cut and save it according to 
        default settings (currently a flat structure of fj_en only for R). 
        """        

        if quickRun:
            parse = True
        
        if source == None:
            self.ps = list()    # list with access paths to all p(arameter lists)
            self.getFileList()
            self.addFiles(parse)
        else:
            self.source=source
            self.readIn()
        
        if quickRun:
            self.deleteRawTS()
            self.deleteIfNot()
            self.writeFlatDict(fileName = 'fj_en_ts_flat.json')
            
    # end def init
    
    
    
    def writeOut(self, fileName=None):
        """Write all dict data to JSON, after converting dates to string
        If subDict = someDict, will use this dict instead of all of self"""
                
        if fileName == None:
            if hasattr(self,'source'):
                fileName = self.source
            else:
                fileName = 'tmpDumpFile.json'
        else:
            if not hasattr(self,'source'):
                self.source=fileName
        
        if not hasattr(self.p()['ts']['date'][0],'split'):
            # This means format is not string...
            print('Converting datetimes to string...')
            self.allstrftime()
                
        #TODO: Exception handling
        with open(fileName,'w') as oFile:
            # It's fine to just write self, this will write all dict keys.
            json.dump(self,oFile)
        print('Succesfully wrote to file "'+fileName+'".')
    # end def writeOut
    
    def readIn(self, source=None):
        """Load data from json 'source' (or self.source if specified)"""
        if source == None:
            if hasattr(self,'source'):
                spirce = self.source
            else:
                source = input('Please specify source file path/name')
            
        with open(source,'r') as iFile:
            iDict = json.load(iFile)
            for key in iDict.keys():
                self[key] = copy.deepcopy(iDict[key])
        
        print('.json loaded, proceeding to reconstruct access tree.\nNote that dates are in pure string format. Run BColl.allstrptime() to convert to python datetime format.')
        self.reconstructPs()
    # end def readIn
    
    
    
    def __repr__(self):
        s = 'BColl (building collection) object, containing '+str(len(self.ps))+' metering timeseries(es).\nAccess structure:\nBColl[buildingID]\n\t"buildingName"\n\t[meterID]\n\t\t[parameter]\n\t\t\t"unit"\n\t\t\t"parameterName"\n\t\t\t"parameterType"\n\t\t\t["tsRaw"]\n\t\t\t\t["date"]\n\t\t\t\t["value"]\n\t\t\t["ts"]\n\t\t\t\t["date"]\n\t\t\t\t["state"]\n\t\t\t\t["diff"] (where applicable)'
        return s
    
    def getFileList(self):
        """Searches './data' for all .txt files and adds them to self.files"""
        self.files = list()
        for fp in glob.glob('data/**/*.txt', recursive=True):
            self.files.append(fp)

    
    def addFiles(self, parse=False): 
        """Goes through all files listed in self.files and attempts to parse 
        the corresponding text. Will create linearly interpolated timeseries if
        parse=True"""
        
        for fileName in self.files:
                        
            # TODO: Set encoding rather than ignoring non-english characters
            with open(fileName, errors='ignore') as iFile:
                self.rows = iFile.readlines()
            
            # Parses lines 1 through 4 for meter/par info, also sets 
            # p = self[bID][mID][pID].
            self.addFileInfo(fileName)        
            # Parse rows for timeseries data
            if parse:
                try:
                    self.parseTSRaw()
                    self.parseTSInterp()
                except Exception as ex:
                    # TODO: Proper exception handling
                    print('Error during TS-parsing of file:\n'+fileName+'.\nExiting.\n')
                    traceback.print_exc()
                    return self
                    
        print('Data ingestion completed!')
    # end def addFiles
    
    
    
    def addFileInfo(self, fileName):
        """Parses the first 4 rows of self.rows and creates + adds relevant data
        to self[bID][mID][pID]"""
        
        r0 = self.rows[0].split(' / ')
        if len(r0)==4: # This is true for all except "palmestedtsalen"
            imID=1
            ipID=2
            ipName=3
        else:           # There's only one exception, no need to do a proper regex analysis...
            imID=2
            ipID=3
            ipName=4
            
        bID = 'b'+re.search('[0-9]+',r0[0]).group()     # Begin with 'b', as keys can't be just numeric
        bName = r0[0][len(bID)+3:] # The full name is everything in the string, after the ID+" - "
        mID = r0[imID] # Meter ID
        pNr = 'p'+r0[ipID] # Parameter ID
        pName = re.search('[^\\t\\n]+',r0[ipName]).group() # Descriptive name of parameter

                
        ## pType is a list, ex ['electricity','state'] or ['cold','return temperature']
        # First part is type of quantity. 3 possibilities        
        if 'el' in mID:
            pType0 = 'electricity'
        elif 'fj' in mID:
            pType0 = 'heat'
        elif 'kb' in mID:
            pType0 = 'cold'
        else:
            print('Warning: Unknown meter type "'+mID+'" in file "'+fileName+'".')
            pType0 = mID
            
        # Possible unique keyword matches: Effekt, Energi, (Temp) retur, (Temp) fram, Flde
        if 'Energi' in pName:
            pType1 = 'Energy'
        elif 'Effekt' in pName:
            pType1 = 'Effect'
        elif 'fram' in pName:
            pType1 = 'TSupply'
        elif 'retur' in pName:
            pType1 = 'TReturn'
        elif 'Flde' in pName:
            pType1 = 'Flow'
        else:
            print('Unknown parameter name "'+pName+'" in file "'+fileName+'".')
            pType1 = pName
                
        pType = [pType0, pType1]
        pID = pType1
        # pID = pType1+pNr  # The parameter number appears completely useless. 
        # Just use the quantity name and trust the meter grouping.
        
        # TODO: Check for unit properly. Currently assume it's last cell
        r3 = self.rows[3].replace('\n','').split('\t') # Somewhat hacky...
        try:
            unitName = re.search('[^\\t\\n]+',r3[-1]).group()
        except:
            # EXTREMELY hacky...
            unitName = re.search('[^\\t\\n]+',r3[-2]).group()
        
        if not bID in self:
            self[bID]=dict(buildingName=bName)
        if not mID in self[bID]:
            self[bID][mID]=dict(meterName = mID)
        # pID will always be newly added
        self[bID][mID][pID]=dict(parameterName = pName, parameterType = pType, 
            fileName=fileName, unit=unitName, accessPath = [bID,mID,pID], 
            log = [], buildingName = self[bID]['buildingName'], 
            parameterNumber = pNr)
        
           
        self.ps.append([bID,mID,pID])
        
    # end def addFileInfo
    
    
    
    def parseTSRaw(self, ip = -1):
        """Internal: Parse timeseries from raw data in self.p(i)
        The default of i = -1 means it uses last added file if not specified"""
        
        ### IDENTIFY LAST ROW WITH PARSEABLE DATA ###
        nBlankRows = 0
        for i in range(len(self.rows)-3):
            try:
                t = datetime.datetime.strptime(self.rows[-1-i].split('\t')[0],"%Y-%m-%d %H:%M")
                break
            except ValueError:
                nBlankRows += 1
        else:
            print('WARNING: No parseable date column found in file: \n'+self.p(ip)['fileName'])
        
        if nBlankRows > 0:
            msg = 'INFO: Detected ' + str(nBlankRows) + ' blank rows at end of file for ' + str(self.ps[ip]) + ' (ip = ' + str(len(self.ps)-1) + ').'
            self.p(ip)['log'] += [msg]
            print(msg)
        
        nData = len(self.rows) - 3 - nBlankRows
        
        self.p(ip)['tsRaw'] = dict(date=[t]*nData, value=[-99]*nData)
        tsRaw=self.p(ip)['tsRaw']
        
        i = 0
        for row in self.rows[-(1+nBlankRows):2:-1]: # Index backwards
            r = row.split('\t')
            try:
                tsRaw['date'][i] = datetime.datetime.strptime(r[0],"%Y-%m-%d %H:%M")
            except Exception as ex:
                # This is temporary while debugging datetimes...
                # traceback.print_exc()
                print('Error during date parsing with ip = '+str(len(self.ps)-1)+'.' )
                print('i = '+str(i)+' r = ' + str(r)+'.\nFile = '+self.p(ip)['fileName'])
                return -1
            # Note: Swedish notation means comma as decimal separator in files:
            tsRaw['value'][i] = float(r[2].replace(',','.'))
            i += 1
        # end for
        
        # Remove any span of more than 2 points where resolution is below nHoursMax
        nDeleted = trimTSSparseSide(tsRaw)
        if nDeleted > 0:
            msg = 'INFO: Deleted '+str(nDeleted)+' sparse datapoints from '+str(self.ps[ip])+' (ip = '+str(len(self.ps)-1)+').'
            print(msg)
            self.p(ip)['log'] += [msg]
        
        # Note how many times there's more than 25 hours between datapoints:
        nDetected = trimTSSparseSingle(tsRaw)
        if nDetected > 0:
            msg = 'Detected '+str(nDetected)+' sparse datapoints in middle of '+str(self.ps[ip])+' (ip = '+str(len(self.ps)-1)+').'
            # print(msg)    
            self.p(ip)['log'] += [msg]
        
        # Ensure strictly increasing (deals with summer->winter-time and duplicate values
        ## Logic: Simply only keep the first value when this happens...
        nDeleted = trimTSDateStrictlyIncreasing(tsRaw)
        if nDeleted > 0:
            msg = 'INFO: Deleted '+str(nDeleted)+' non-increasing datepoints from '+str(self.ps[ip])+' (ip = '+str(len(self.ps)-1)+').'
            print(msg)
            self.p(ip)['log'] += [msg]
        
        # Negate the effects of meter replacements.
        if self.p(ip)['parameterType'][1] in ['Energy']:
            nRaised = raiseTSValueNotDecreasing(tsRaw)
            if nRaised > 0:
                msg = 'INFO: Possible meter replacement or meter state reset of ' + str(self.ps[ip])+' (ip = '+str(len(self.ps)-1)+').\n\tRaised ' + str(nRaised) + ' points to match previous.'
                print(msg)
                self.p(ip)['log'] += [msg]
        
    # end parseTSRaw
      
      
        
    def parseTSInterp(self, ip = -1):
        """Creates the interpolated state (and diff, where applicable) time-
        series ['ts'] to parameter stream 'ip', based on ['tsRaw']"""
        
        tsRaw = self.p(ip)['tsRaw']
        
        date_min = min(tsRaw['date']).replace(minute=0) + oneHour
        date_max = max(tsRaw['date']).replace(minute=0)
        date_diff = date_max-date_min
        nHours = int( date_diff.days*24 + date_diff.seconds/3600 + 1 )
        # datetime.timedelta only has days and seconds
        # The +1 because there's 1 hour more than the duration of the span
        
        # Potential todo: Make this a pandas frame?
        ## Not necessary if I just collect data here and view it in R
        self.p(ip)['ts'] = dict(date=[date_min] * nHours,
        state = [-99] * nHours)
        ts = self.p(ip)['ts']
        
        for i in range(1,nHours):
            ts['date'][i] = ts['date'][i-1] + oneHour
        
        # Create temporary second-since-epoch timestamp vectors for interp
        dateSSE = [dat.timestamp() for dat in ts['date']] 
        dateSSER = [dat.timestamp() for dat in tsRaw['date']]
        
        #print('nr logged hours = '+str(len(dateSSER))+'\nnr interpolated hours = '+str(len(dateSSE)))
        self.p(ip)['fractionMissing'] = 1 - len(dateSSER)/len(dateSSE)
        if self.p(ip)['fractionMissing'] > 0.2:
            msg = 'WARNING: Over 20% interpolated datapoints in '+str(self.ps[ip])+' (ip = '+str(len(self.ps)-1)+'). File:\n'+self.p(ip)['fileName']
            print(msg)
            self.p(ip)['log'] += [msg]
        
        # This is the only line requiring numpy, can write own interpolation
        # routine if need to send to systems without numpy
        ts['state'] = list( np.interp(dateSSE, dateSSER, tsRaw['value']) )
        
        if self.p(ip)['parameterType'][1] in ['Energy']:
            ts['diff'] = [-99] * nHours
            for i in range(nHours-1):
                ts['diff'][i] = ts['state'][i+1]-ts['state'][i]
            ts['diff'][-1] = ts['diff'][-2] # 
        
    # end def parseTS
    
    
    
    ### REPRESENTATION AND INFO METHODS ###    
    def writeMeterInfo(self, filename='tmpfile.txt'):
        """Writes a tree with all buildings, meters and parameters to 'filename'"""
        
        with open(filename,'w') as of:
            of.write('All buildings, meters and parameters available to us:\n\n') 
        
            for bID in self.keys():
                of.write(bID+', '+self[bID]['buildingName']+'\n')
                for mID in self[bID].keys():
                    if not mID == 'buildingName':
                        of.write('\t'+mID+'\n')
                        for pID in self[bID][mID].keys():
                            if not pID == 'meterName':
                                of.write('\t\t'+pID+'\n')
                                #of.write('\t\t'+pID+', '+str(len(self[bID][mID][pID]['tsRaw']['date']))+' datapoints\n')
                                #of.write('\t\t\tDate span: '+self[bID][mID][pID]['ts']['date'][0]+' - '+self[bID][mID][pID]['ts']['date'][-1]+'\n')
                                
        print('Task completed without errors')
        
    
    def writeMeterSummary(self, filename='tmpfile.txt', prefixesToInclude = ['fj','kb']):
        """Prints a tree of all buildings and meters to file 'filename'"""
        with open(filename,'w') as of:
            of.write('Byggnader och mätare.\nByggnader listas med en indent, tillhörande mätare med två indenter precis under.\n')
            for bID in self.keys():
                of.write('\t'+bID+' - '+self[bID]['buildingName']+'\n')
                for mID in self[bID].keys():
                    if not mID == 'buildingName' and mID[:2] in prefixesToInclude:
                        of.write('\t\t'+mID+'\n')
                    
        print('Task completed')
    
    
    
    ### INTERNAL ORGANISATION METHODS ###
    
    def p(self, i=-1):
        """Returns a reference to parameter dict i
        If i not specified, returns last added dict"""        
        return self [self.ps[i][0]] [self.ps[i][1]] [self.ps[i][2]]
        
    def pCond(self, qType=None, uType=None):
        """Generator yielding all attached meter serieses fulfilling conditions.
        If no conditions specified, returns all series.
        quantityType: 'electricity'|'heat'|'cold'
        unitType: 'Energy'|'Effect'|'TSupply'|'TReturn'|'Flow'
        Additional conditions To Be Added."""
        for i in range(len(self.ps)):
            ret = True
            if qType != None and self.p(i)['parameterType'][0] != qType:
                ret = False
            if uType != None and self.p(i)['parameterType'][1] != uType:
                ret = False
            
            if ret:        
                yield(self.p(i))
    # end def pAll
    
    
    
    def reconstructPs(self):
        self.ps = list()
        for bID in self.keys():
            for mID in [key for key in self[bID] if not key == 'buildingName']:
                for pID in [key for key in self[bID][mID] if not key == 'meterName']:
                    self.ps.append([bID,mID,pID])
        print('BColl.ps reconstructed, found '+str(len(self.ps))+' timeseriesses')
    
    
    
    def allstrftime(self):
        """Converts all date objects in 'ts' and 'tsRaw' to strings"""
        for p in self.pCond():
            for i in range(len(p['ts']['date'])):
                p['ts']['date'][i] = p['ts']['date'][i].__format__("%Y-%m-%d %H:%M")
            if 'tsRaw' in p.keys():
                for i in range(len(p['tsRaw']['date'])):
                    p['tsRaw']['date'][i] = p['tsRaw']['date'][i].__format__("%Y-%m-%d %H:%M")
#            p['ts']['date'] = [t.__format__("%Y-%m-%d %H:%M") for t in p['ts']['date']]
#            p['tsRaw']['date'] = [t.__format__("%Y-%m-%d %H:%M") for t in p['ts']['date']]
        print('Converted all datetimes to string')
       
            
    def allstrptime(self):
        """Converts all dates in 'ts' and 'tsRaw' to datetimes  from string."""
        for p in self.pCond():
            p['ts']['date'] = [datetime.datetime.strptime(t,"%Y-%m-%d %H:%M") for t in p['ts']['date']]
            if 'tsRaw' in p.keys():
                p['tsRaw']['date'] = [datetime.datetime.strptime(t,"%Y-%m-%d %H:%M") for i in p['ts']['date']]
        print('Converted all datetime to dt-objects')


    def deleteRawTS(self):
        """Removes all tsRaw entries from self"""
        for p in self.pCond():
            if 'tsRaw' in p.keys():
                p.__delitem__('tsRaw')
        print('Removed all attached raw timeseries')
    
    
    def deleteIfNot(self, mType=['fj'], pType=['Energy']):
        """Accepts types of meter ('fj'|'kb'|'el') and parType
        ('Energy'|'Effect'|'Flow'|'TSupply'|'TReturn') and deletes all 
        meters/parTSs not included"""
        
        print('Removing all streams not adhering to criteria: \nmeterType = '+str(mType)+', parameterType = '+str(pType)+'.')
        for bID in self.keys():
            mIDList = [mID for mID in self[bID].keys() if not mID == 'buildingName']
            for mID in mIDList:
                if not mID[:2] in mType:
                    self[bID].__delitem__(mID)
                else:
                    pIDList = [pID for pID in self[bID][mID].keys() if not pID == 'meterName']
                    for pID in pIDList:
                        if not self[bID][mID][pID]['parameterType'][1] in pType:
                            self[bID][mID].__delitem__(pID)
        self.reconstructPs()
        
        
    def writeFlatDict(self, fileName='dataDumpFlat.json'):
        """Creates and writes a flat version of self, for easier R handling"""
        
        if not hasattr(self.p()['ts']['date'][0],'split'):
            # This means format is not string...
            print('Converting datetimes to string...')
            self.allstrftime()
        
        oDict = dict()
        i = 1
        for p in self.pCond():
            iName = 'p' + str(i) # Names should start with a letter, for compatibility
            oDict[iName] = copy.deepcopy(p)
            oDict[iName]['meterName'] = p['accessPath'][1]
            i += 1
        
        
        with open(fileName,'w') as of:
            json.dump(oDict, of)
        print('Succesfully wrote to '+fileName)
            
# end class


    
### UTILITY FUNCTIONS NOT BOUND TO CLASS ###
def raiseTSValueNotDecreasing(ts):
    """Takes a referense to a timeseries('date','value') assumed to be only
    increasing. If there is a suddent jump to <10% of previous value, adds the 
    previous value to all following values (in case of meter reset)."""
    nRaised = 0
    for i in range(1,len(ts['date'])):
        if ts['value'][i] < 0.1*ts['value'][i-1]:
            ts['value'][i:] = [t+ts['value'][i-1] for t in ts['value'][i:]]
            nRaised += 1
    return nRaised
    
def trimTSDateStrictlyIncreasing(ts):
    """Takes a referense to a dateVector, remove any datapoint whos date is not
    strictly after the last datepoint. Returns number of deleted points"""
    nDeleted=0
    # Assume we have 'date' and 'value'
    
    i=1
    while i < len(ts['date']):
        if ts['date'][i] <= ts['date'][i-1]:
            ts['date'].__delitem__(i) 
            ts['value'].__delitem__(i)
            nDeleted += 1
        else:
            i += 1 # Only increment i if nothing deleted
        # Potentially very slow (if lots to delete)
    return nDeleted

def trimTSSparseSide(ts, nCons=5, nHoursMax=72, beginning=True, end=True):
    """Takes a timeseries('date','value') and removes datapoints until the first
    nCons datapoints are all within nHoursMax hours of each other.
    beginning and end specify which ends to do this from"""
    dtMax = oneHour*nHoursMax
    nDeleted = 0
    
    if beginning:
        i = 0
        while i < nCons and len(ts['date']) > nCons:
            if ts['date'][i+1]-ts['date'][i] > dtMax:
                ts['date'].__delitem__(i)
                ts['value'].__delitem__(i)
                nDeleted += 1
                i = max(0,i-1)
            else:
                i += 1
    if end:
        j = 1
        while j < nCons and len(ts['date']) > nCons:
            if ts['date'][-j]-ts['date'][-j-1] > dtMax:
                ts['date'].__delitem__(-j)
                ts['value'].__delitem__(-j)
                nDeleted += 1
                j = max(1,j-1)
            else:
                j += 1
    
            
    return nDeleted
        
def trimTSSparseSingle(ts, nHoursMax=25, delete=False, qDual=False):
    """Takes a timeseries('date','value') and removes all points which in both 
    directions have a gap of > nHoursMax. Assumes ts is increasing.
    Returns number of deleted datapoints"""
    dtMax = oneHour*nHoursMax
    nDetected = 0
    i=0
    while i<(len(ts['date'])-1):    # Note the -1, last datapoint can't be checked this way.
        fSparse = False
        if qDual:
            if (ts['date'][i]-ts['date'][i-1]) > dtMax and (ts['date'][i+1]-ts['date'][i]) > dtMax:
                fSparse = True
        else:
            if (ts['date'][i+1]-ts['date'][i]) > dtMax:
                fSparse = True
        
        if fSparse:    
            if delete:
                ts['date'].__delitem__(i)
                ts['value'].__delitem__(i)
                i -= 1
            nDetected += 1        
        i += 1
                
    # For last and first datapoint, just check adjacent
    if (ts['date'][i]-ts['date'][i-1]) > dtMax:
        if delete:
            ts['date'].__delitem__(i)
            ts['value'].__delitem__(i)
            i -= 1
        nDetected += 1
        
    if (ts['date'][1]-ts['date'][0]) > dtMax:
        if delete:
            ts['date'].__edlitem__(0)
            ts['value'].__delitem__(0)
            i -= 1
        nDetected += 1
    
    return nDetected


