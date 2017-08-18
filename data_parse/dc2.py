"""PColl.py. Contains PColl class, which is similar to the BColl class from 
dc.py in its intentions, but has a flat structure (sorts by Parameter instead 
of Building). Will not implement recreating of data as of yet. To get data, 
parse it using BColl, save it with BColl.writeFlatDict, then load it with
PColl(source = 'JSON.json').
Also: PColl will not itself be a dict, but simply store dicts as attrs.
It's attribute 'c' will always point to the "current" dict, so assuming 
methods can be executed to make modifications without risk of losing data.
PColl.c['pts'] will be a pandas data frame, for use with SciPy packages"""

import re, json, os, glob, datetime, traceback, copy, xlrd
import dc2u
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd   
import dc   # For use of generic helper functions
import statsmodels.api as sm
import statsmodels.formula.api as smf
from pandas import DataFrame as pddf

oneHour = datetime.timedelta(seconds=3600)

class PColl():
    """Main module Class. Method list:
    PColl.p(i=-1): Return reference to currently active dict/pStream
    """
    def __init__(self, source = 'fj_en_ts_flat.json', 
    outTSource = 'TOutside_Molndal_20130101_20170425.json',
    fromBColl = True, tCutT = 15, addLRM1 = False):
        
        self.dl = list()    # List of lists for references to all dicts (+names)
        self.cd = 0         # Current active dict id (for bookkeeping)
        self.cp = -1        # Currently active stream id
        self.ps = list()    # Summary of references to meters in current dict
        # Always assume ps refers to self.c. Thus, always switch c using 
        # builtin method (to be created)
        
        with open(source, 'r') as iFile:
            self.dl.append( [json.load(iFile), 'RawInput'] )
        print('Loaded data from file "' + source + '".')
        
        self.c = self.dl[0][0]
        self.reconstructPs()
        
        self.strptimeSelf()
        self.convertToPandas()
        
        self.ensureMW()
               
        if not outTSource == None:
            self.addOutsideT(fileName = outTSource)
            if addLRM1:
                self.addLRM1PredToAll(tCutT)
    # end def __init__
    
    
    
    
    
    ### ORGANISATIONAL ###
    def changeC(self, newDict = 0):
        """Changes currently active dict to newDict ID. dict Names TBA"""
        self.c = self.dl[newDict][0]
        self.reconstructPs()
    
    def p(self, i=None):
        """Returns currently active stream"""
        if i == None:
            return self.c[self.ps[self.cp]]
        else:
            return self.c[self.ps[i]]
            
    def pCond(self, crits = None):
        """Generator that yields all ps in .c. Optionally include filtering
        criteria 'crits[= None]'.
        Accepts a list of strings 'crits'.
        Yield p if each crit in crits is represented at least prtly in 
        any of the paths"""

        if not crits == None:
            crits = list(crits)
        
        for pName in self.ps:
            if crits == None:
                qReturn = True
            else:
                # Do filtering
                ap = self.c[pName]['accessPath']
                #qReturn = all( [any( [crit in path for path in ap] ) for crit in crits] )
                for crit in crits:
                    if not any([crit in path for path in ap]):
                        qReturn = False
                        break
                else:
                    qReturn = True
                
            if qReturn:
                yield self.c[pName]
        #for i in range(length(self.ps)):
            #yield(self.p(i))
        # Could also be: for p in self.ps: yield self.c[p]
    
    def pFind(self, crits):
        """Returns list with all hits from pCond(crits)
        If only one hit, returns p instead of [p...]"""
        pLO = [p for p in self.pCond(crits)]
        if len(pLO) == 1:
            return pLO[0]
        elif len(pLO) == 0:
            return None
        else:
            return pLO
        

    def reconstructPs(self):
        """Assuming self.c, reconstruct self.ps"""
        self.ps = [key for key in self.c.keys()]
        print('.ps reconstructed with '+str(len(self.ps))+' pStreams')
    # end reconstructPs
    
    ### FILE SYSTEM ###
    def writeOut(self, fileName):
        """Write flat dict into JSON format, using currently active dict 'c'
        Creates a deepcopy of the dict and converts datetimes to string"""
        oDict = copy.deepcopy(self.c)
        
        # Convert datetimes to string
        for key in oDict.keys():
            p = oDict[key]
            strftimeTS(p['ts'])
                
        #TODO: Exception handling
        with open(fileName,'w') as oFile:
            # It's fine to just write self, this will write all dict keys.
            json.dump(oDict,oFile)
        print('Succesfully wrote to file "'+fileName+'".')
    # end def writeOut
    
    
    def parseERapportFiles(self):
        """Loading CFAB xls files from E-rapport (CFAB)"""
        # Just do everything for 2015 files and concatenate 2016 files...
        # NO GENERALITY!
        print('Adding E-rapport files...')
        #dirName = './data/ERapport_CFAB'
        dirName = os.path.join('.','data','ERapport_CFAB')
        fileNames = os.listdir(dirName)
        # fileName: ObID-buildingName-mID-201X.xls

        for fName in fileNames:

            if not '-2015.' in fName:
                continue
            
            fnSplit = fName.split('-')
            bID = fnSplit[0]
            bName = fnSplit[1]
            mID = fnSplit[2]
            
            filePath = os.path.join(dirName,fName)
            filePath16 = filePath.replace('-2015.','-2016.')
            filePath17 = filePath.replace('-2015.','-2017.')
            #sheet = xlrd.open_workbook(filePath).sheet_by_index(0)
            sheet = xlrd.open_workbook(filePath).sheet_by_index(0)
            subID = sheet.cell_value(rowx=3, colx=1)
            bAddress = sheet.cell_value(rowx=3, colx=3)
            
            unit = sheet.cell_value(rowx=6, colx=1)
            
            ts = pd.read_excel(filePath, 
                                header = 9, skip_footer = 3, parse_cols = 1, index_col = 0)
            
            # Find and append year 2016
            fn16 = fName.replace('-2015.','-2016.')
            ts16 = pd.read_excel(filePath16, 
                                header = 9, skip_footer = 3, parse_cols = 1, index_col = 0)
            ts = ts.append(ts16)
            
            # Add year 2017 if it exists
            fn17 = fName.replace('-2015.','-2017.')
            if fn17 in fileNames:
                ts17 = pd.read_excel(filePath17, 
                                header = 9, skip_footer = 3, parse_cols = 1, index_col = 0)
                ts = ts.append(ts17)
            
            # Rename to "date", "diff"
            ts.rename(columns={'Förbrukning': 'diff'}, inplace=True)
            ts.index.name = 'date'
            
            if unit[0] == 'k':
                ts['diff'] *= 0.001
            
            accessPath = [bID, mID, 'Energy']
            buildingName = bName + ', ' + bAddress
            
            pOut = dict(buildingName = buildingName, accessPath = accessPath, ts = ts)
            
            self.addP(pOut)
        
        
    
    def parseLandlordFiles(self):
        """Adds files from Landlord, with correct names"""
        print('Adding Landlord files...')
        
        #dirName = './data/Landlord/'
        dirName = os.path.join('.','data','Landlord')
        # fName = 'O60138-JSP-fj_VS1VMM1.xlsx'
        fileNames = os.listdir(dirName)
        
        for fName in fileNames:
        
            tsRaw = pd.read_excel(os.path.join(dirName, fName),  header = 4, 
                                skip_footer = 3, index_col = 1, parse_cols = 2) 
            # parse_cols = [2] gives error, have to overparse and drop
            tsRaw.drop('Start', axis=1, inplace=True)
            tsRaw.index.name = 'date'
            tsRaw.rename(columns={'Ställning': 'state'}, inplace=True)

            # Create new ts and interpolate.
            date_min = tsRaw.index[-1].replace(minute=0, second=0)+oneHour
            date_max = tsRaw.index[0].replace(minute=0, second=0)
            ts = pddf(index = pd.date_range(start=date_min, end=date_max, freq='H'))
            ts.index.name = 'date'

            dateSSE = [dat.timestamp() for dat in ts.index]
            dateSSER = [dat.timestamp() for dat in tsRaw.index]
            ts['state'] = np.interp(dateSSE, dateSSER[::-1], tsRaw['state'][::-1])

            #np.interp(dateSSE, dateSSER[::-1], tsRaw['state'][::-1])

            ts['diff'] = np.nan
            ts['diff'][:-1] = ts['state'][1:].values - ts['state'][:-1].values
            ts.drop(ts.index[-1], axis=0, inplace=True)

            fns = fName.split('-')
            buildingName = fns[1]
            accessPath = [fns[0], fns[2][:-5], 'Energy']
            
            # El is reported in kWh here, convert to MWh
            if '-el_' in fName:
                ts['diff'] *= 0.001

            pOut = dict(buildingName = buildingName, accessPath = accessPath, ts = ts)

            self.addP(pOut)
        
    def parseMetryFiles(self):
        """Parses and adds pStreams from all files in data/Metry"""
        print('Adding Metry files...')
        
        #dirName = './data/Metry/'
        dirName = os.path.join('.','data','Metry')
        fileNames = os.listdir(dirName)
        
        for fName in fileNames:
            if '~' in fName:
                continue

            tsIn = pd.read_excel(os.path.join(dirName, fName), header = 7, 
                parse_cols = 1, index_col = 0)
            
            tsIn.rename(columns = {tsIn.columns[0]: 'diff'}, inplace=True)
            tsIn['diff'] *= 0.001
            
            # date has format "'YYYY-mm-dd HH:MM" (note the ') for some reason
            # Since single file, do manual override
            newIndex =  [datetime.datetime.strptime(dat, '%Y-%m-%d %H:%M') for dat in tsIn.index.values]
            ts = pddf({'diff': tsIn['diff']}, index = newIndex)
            
            # ts[dateName] = [datetime.datetime.strftime(dat,frmt) for dat in ts[dateName]]
            
            fns = fName.split('-')
            bName = fns[1]
            accessPath = [fns[0], fns[2], 'Energy']
            pOut = dict(buildingName = bName, accessPath = accessPath, ts = ts)

            self.addP(pOut)
        
    
    ### SIMPLE DO-FOR-ALL METHODS ###
    def addLRM1PredToAll(self, tCutT = 15):
        print('Adding Linear prediction with default cutT to all streams...', end = '')
        for p in self.pCond():
            try:
                addLRM1Pred(p, tCutT)
                addHourFactor(p, modelName = 'lrm1')
            except Exception as ex:
                print('WARNING: Failed to add linear prediction to '+str(p['accessPath']))
        print('Done')
        
    
    def ensureMW(self):
        """Converts all units starts with 'k' into one starting with 'M'"""
        for p in [p for p in self.pCond() if 'unit' in p.keys()]:
            if p['unit'][0] == 'k':
                p['ts']['diff'] *= 0.001
                p['unit'] = 'M'+p['unit'][1:]
                
    
    
    ### INTERNAL DATA HANDLING ###
    def strptimeSelf(self):
        """Send all pStreams through strptimeTS"""
        print('Converting strings to datetime...', end = '')
        for p in self.pCond():
            strptimeTS(p['ts'])
        print('Done')
        
    def convertToPandas(self, addHours = True):
        """Converts all attached 'ts' and 'tsRaw' to pandas objects with
        timeseries being the index"""
        print('Converting to pandas dataframes...', end = '')
        for p in self.pCond():
            p['ts'] = pddf(p['ts'])
            p['ts'].set_index('date', drop=True, inplace=True)
            if addHours:
                p['ts']['hour'] = [dto.hour for dto in p['ts'].index]
            if 'tsRaw' in p:
                p['tsRaw'] = pddf(p['tsRaw'])
                p['tsRaw'].set_index('date', drop=True, inplace=True)
        
            
        print('Done')
        
    def addOutsideT(self, fileName):
        """Adds outside T to all attached series"""
        print('Incorporating outsideT...', end = '')
        with open(fileName, 'r') as iFile:
            outTDict = json.load(iFile)
        outTts = outTDict['data']
        strptimeTS(outTts, frmt = '%Y-%m-%dT%H:%M:00', dateName='datetime')
        
        for p in self.pCond():
            qNaNsPresent = dc2u.addTSColsToPandas(p['ts'], outTts, 't', dateName='datetime')
            if qNaNsPresent == 1:
                p['ts'].dropna(how='any', inplace=True)
        
        print('Done')
    
    def addP(self, p):
        """Add a stream 'p' to the currently active dict self.c"""
        nP = len(self.c.keys())
        self.c['p'+str(nP+1)] = p
        self.reconstructPs()
        
        
    ### END OF CLASS DEFINITION ###
   
    
### LINEAR STATISTICS ###

def addLRM1Pred(p, tCutT = 15, returnR2 = False):
    """Adds linear regression between Heat Load ('diff') and outdoor T
    to p['ts']['lrm1']. Returns R2 if returnR2 = True. 
    tCut sets the breakpoint. If i=None, uses self.cp to determine stream"""
    
    ts = p['ts']
    ts['tCut'] = [min(t,tCutT) for t in ts['t']]

    # fit OLS linear regression model rm1:
    p['lrm1Model'] = smf.ols('diff ~ tCut', data=ts).fit()
    
    ts['lrm1Pred'] = p['lrm1Model'].predict()

    
    if returnR2:
        return p['lrm1Model'].rsquared
    
def addHourFactor(p, modelName = 'lrm1', tCutT = 15):
    """Adds HourFactor -- mean difference between observed and predicted 
    heat load -- by hour of the day. Attached name is ['modelNameHourFactor']
    Only considers hours below cut temperature, improve modularity as needed."""

    ts = p['ts']
    hourV = np.array([dto.hour for dto in ts.index])
    hourFactor = [0]*24
    for i in range(24):
        tvec = [(h==i) & (t<tCutT) for (h, t) in zip(hourV, ts['t'].values)]     # Truth vector
        hourFactor[i] = pddf.mean(ts.loc[tvec, 'diff'] - ts.loc[tvec, modelName+'Pred'])
    
    p[modelName+'HourFactor'] = hourFactor

### INTERNAL DATA FUNCTIONS ###
    
def strptimeTS(ts, frmt = '%Y-%m-%d %H:%M', dateName='date'):
    """Converts all elements in ts['date'] from string to datetimeObj."""
    
    if hasattr(ts[dateName][0],'join'): # True for string, not for datetime
        # This is really increadibly slow, use list comprehension if needed...
        #for i in range(len(ts[dateName])):
        #    ts[dateName][i] = datetime.datetime.strptime(ts[dateName][i],frmt)
        ts[dateName] = [datetime.datetime.strptime(dat,frmt) for dat in ts[dateName]]

def strftimeTS(ts, frmt = '%Y-%m-%d %H:%M', dateName='date'):
    """Converts all elements in ts['date'] to string from datetimeobj"""
    
    ts[dateName] = [datetime.datetime.strftime(dat,frmt) for dat in ts[dateName]]
            
#def addTSColsToPandas(df, ts, colNames, dateName = 'date', defMiss = np.nan):
#     """Adds columns defined by keys "colNames" from iterable timeseries "ts" 
#    into pandas dataframe "df", assuming the former has a separate 'date' 
#    column and the latter is indexed by date."""   




    
        
