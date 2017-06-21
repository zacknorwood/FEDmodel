"""Utility functions for FED_Ans, corresponding to PColl data from 
dc2.py"""
import copy, json, datetime, csv
from pandas import DataFrame as pddf
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf

DEFAULT_OUTSIDE_T_FILE = 'outTFED_20170613.json'

def convertCoefsToESig(coefs, tCutT=15):
    """Converts regression coefficients to [baseload, load per degree below 
    tCutT]"""
    bl = coefs[0] + tCutT*coefs[1]
    return [bl, -coefs[1]] # eSig = [...]
# end def

def mergePDDFs(dfs, factors = None):
    """Accepts a list of references to pandas dataframes. Finds the intersects 
    and adds all of them into the first element (inline replace)"""
    if factors == None:
        factors = [1]*len(dfs)
    
    dfm = copy.deepcopy(dfs[0])
    dfm['diff'] *= factors[0]
    
    i = 1
    for dfi in dfs[1:]:
        inters = dfm.index.intersection(dfi.index)
        if len(inters) < len(dfm.index):
            dfm = dfm.loc[inters, ['t','diff']]
        dfm['diff'] += dfi.loc[inters, 'diff']*factors[i]
        i += 1
        
    return dfm



def pCond(b, crits = None):
    """Generator that yields all ps in .c. Optionally include filtering
    criteria 'crits[= None].
    Accepts a list of strings 'crits'.
    Yield p if each crit in crits is represented at least prtly in 
    any of the paths"""

    if not crits == None:
       if hasattr(crits,'join'): # Is string, not list
        crits = list(crits) 
    
    if hasattr(b, 'keys'):
        # if b is dict, turn into list
        b = [b[key] for key in b.keys()]
    
    for p in b:
        pPath = p['accessPath']
        if crits == None:
            qReturn = True
        else:
            # Do filtering
            #qReturn = all( [any( [crit in path for path in ap] ) for crit in crits] )
            
            for crit in crits:
                if not any([crit in path for path in pPath]):
                    qReturn = False
                    break
            else:
                qReturn = True
            
        if qReturn:
            yield p
    #for i in range(length(self.ps)):
        #yield(self.p(i))
    # Could also be: for p in self.ps: yield self.c[p]



def pFind(b, crits):
    """Returns list with all hits from pCond(crits)
    If only one hit, returns p instead of [p]"""
    pLO = [p for p in pCond(b,crits)]
    if len(pLO) == 1:
        return pLO[0]
    elif len(pLO) == 0:
        return None
    else:
        return pLO


def createCommonP(pList):
    """Accepts a list of parameter streams (p) including p['ts'].
    Concatenates accessPath, buildingName, log
    Merges ts using dc2u.mergePDDFs"""
    
    pMerged = copy.deepcopy(pList[0])
    
    if len(pList) > 1:
        for p in pList[1:]:
            for atn in ['accessPath', 'buildingName', 'log']:
                if atn in p.keys():
                    pMerged[atn] = list(pMerged[atn]) + list(p[atn])
            
            pMerged['ts'] = mergePDDFs([pMerged['ts'], p['ts']])
    
    return pMerged
    
    
    
def addHourMean(p, tCutT = 15, overWrite = False):
    """Adds hour mean to p['hourMean'], assuming '['ts']['diff'] and .index"""
    if (not 'hourMean' in p.keys()) or (overWrite == True):
        
        ensureOutsideT_area([p]) 
        ts = p['ts']
        meanVal = pddf.mean(ts['diff'])
        hMean = [0]*24
        
        #hourV = np.array([dto.hour for dto in ts.index])
        hourV = ts['hour']
        
        for i in range(24):
            if type(tCutT) ==  type(None):
                tvec = [h==i for h in hourV]
            else:
                tvec = [(h==i) & (t<tCutT) for (h, t) in zip(hourV, ts['t'].values)]     # Truth vector
            
            hMean[i] = pddf.mean(ts.loc[tvec, 'diff'] - meanVal)
        
        p['hourMean'] = hMean    



def nPointsAverage(v, n=24):
    """Return a list of values of length (ceil(len(v)/n)), where each values is
    the average of the n following values"""
    nIn = len(v)
    nOut = int(np.ceil(len(v)/n))
    
    vOut = [0]*nOut
    for i in range(nOut):
        if i < (nOut-1):
            vOut[i] = sum(v[(i*24):(i*24)+23])/n
        else:
            vTmp = list(v[(i*24):]) # List guards against len(int) error
            vOut[i] = sum(vTmp)/len(vTmp)
    return vOut



def addTSToArea(a, b):
    """Add merged area timeseriess to area list "a", by parsing a[i]['meters']
    and pulling these meters using b.pFind(crits)"""
    aWTS = [ar for ar in a if len(ar['meters'][0]) > 0]
    
    for area in aWTS:
        mtrs = area['meters']
                
        area['pMissing'] = 0
        dfs = list() # list of dataframes belonging to that area
        meterFactors = list()
        for mtr in mtrs:
            mtrp = b.pFind([mtr[0], mtr[1]])
            if type(mtrp) == type(None):
                print('WARNING: Missing meter ' + str(mtr) + '.')
                area['pMissing'] += 1
            else:
                dfs.append( mtrp['ts'] )
                meterFactors.append(mtr[2])
                
                
        if len(dfs) == 1:
            area['ts'] = copy.deepcopy(dfs[0])
            area['ts']['diff'] *= meterFactors[0]
        elif len(dfs) > 1:
            area['ts'] = mergePDDFs(dfs, meterFactors)
        else:
            print('No meter streams found for area '+str([area['idr'],area['name']])+'.')
    
    # For now: If any meters are missing, we want to delete the entire TS
    # (but keep the area)
    for area in aWTS:
        if area['pMissing'] > 0:
            if 'ts' in area.keys():
                area.__delitem__('ts')
   
    print('Area timeseries incorporation Done')

#inters = dfm.index.intersection(dfi.index)




def collectAllAreaTS(a):
    """Return a new panda frame with 'diff' for each a[area]['ts']"""
    
    outFrame = pddf(index = a[0]['ts'].index)

    # Set index by repeated unioning
    for area in [ar for ar in a if 'ts' in ar.keys()]:
        outFrame = outFrame.reindex(outFrame.index.union(area['ts'].index))
        
    # Exclude all values before a certain date
    outFrame = outFrame.loc[outFrame.index >= datetime.datetime(2015,1,1)]

    # Add each timeseries by intersect
    for area in a:
        colName = area['idr'] + ', ' + area['name']
        outFrame[colName] = np.nan
        if 'ts' in area.keys():
            ts = area['ts']
            outFrame.loc[outFrame.index.intersection(ts.index), colName] = ts['diff']
        # Areas without ts will be blank columns
    
    return outFrame



def ensureOutsideT_area(a, fileName=DEFAULT_OUTSIDE_T_FILE, force = False, date_min = None):
    """Adds outside T to area['ts']['t'] for each area in a"""
    
    fProcessed = False
    
    for area in a:
        if not 'ts' in area.keys():
            continue
        if not type(date_min) == type(None):
            area['ts'] = area['ts']
        
        ts = area['ts']
        # Add hour vector if not present
        if not 'hour' in ts or force==True:
            ts.loc[:,'hour'] = [pd.to_datetime(dat).hour for dat in ts.index.values]
            # Should I convert all indices to pd.tslib.Timestamp?ance w

        # Add outsideT if not present
        if not 't' in ts or force==True:
            if not fProcessed:
                with open(DEFAULT_OUTSIDE_T_FILE,'r') as iFile:
                    outTDict = json.load(iFile)
                # Use some special cases to read this data...
                if 'data' in outTDict.keys():
                    outTts = outTDict['data']
                    strptimeTS(outTts, frmt = '%Y-%m-%dT%H:%M:00', dateName='datetime')
                else:
                    outTts = dict(datetime = outTDict['date'], t = outTDict['value'])
                    strptimeTS(outTts, frmt = '%Y-%m-%dT%H:%M:00', dateName='datetime')
            addTSColsToPandas(ts, outTts, 't', dateName='datetime')
            
            # drop all dates before 2015-01-01T00:00:00, OR just dropna
            #ts.dropna(inplace=True)
            #ts = ts[ts.index >= datetime.datetime(2015,1,1)]
            
        # end if



def addAreaESigs(a, tCutT = 15, hDay = 8, hNight = 18):
    
    for area in a:
        #ts.dropna(inplace=True)
        ts = area['ts']
        
        ts = ts[ts.index >= datetime.datetime(2015,1,1)]
        
        nightV = [(h<hDay)or(h>hNight-1) for h in ts['hour']]
        dayV = [(h>hDay-1)and(h<hNight) for h in ts['hour']]
        
        # Force redraw...
        if 'tCut' in ts:
            ts.drop('tCut', axis=1, inplace=True)
        ts.loc[:,'tCut'] = [min(t,tCutT) for t in ts['t']]
        
        allRM1 = smf.ols('diff ~ tCut', data=ts).fit()        
        nightRM1 = smf.ols('diff ~ tCut', data=ts[nightV]).fit()
        dayRM1 = smf.ols('diff ~ tCut', data=ts[dayV]).fit()
        
        area['ts'] = ts # Old reference was broken by replacement
        
        area['eSig6'] = [convertCoefsToESig(mdl.params) for mdl in [allRM1, nightRM1, dayRM1]]
        
        x = [min(area['ts']['t']-0.5), tCutT, max(area['ts']['t'])+0.5]
        area['ppESig'] = [getESigLines(x, area['eSig6'][i]) for i in range(3)]
        area['ppEx'] = x


def getESigLines(x, k):
    """Accept plot-breakpoints and base+slope, outputs sorted plot-lines"""
    return [k[0]+k[1]*(x[1]-x[0]), k[0], k[0]]


def writeAreaESigs(a, fileName = None, tCutT = 15, hDay = 8, hNight = 18):
    """Export night-time energy signature for each area in a to file"""
    # First: identify all areas with heat load...
    aa = [ar for ar in a if 'ts' in ar.keys()]
    
    lesigs = list()
        
    ensureOutsideT_area(aa, force=False)
    
    for area in aa:
        try:
            ts = area['ts']

            nightV = [(h<hDay)or(h>hNight-1) for h in ts['hour']]
            dayV = [(h>hDay-1)and(h<hNight) for h in ts['hour']]
            
            ts['tCut'] = [min(te,tCutT) for te in ts['t']]
            
            allRM1 = smf.ols('diff ~ tCut', data=ts).fit()
            nightRM1 = smf.ols('diff ~ tCut', data=ts[nightV]).fit()
            dayRM1 = smf.ols('diff ~ tCut', data=ts[dayV]).fit()

            #lesig.append([convertCoefsToESig(mdl.params) for mdl in [p['lrm1Model'], nightRM1, dayRM1]])
            lesigs.append([area['idr'], area['name']] + 
                        convertCoefsToESig(allRM1.params) + 
                        convertCoefsToESig(nightRM1.params) + 
                        convertCoefsToESig(dayRM1.params))
        except:
            print('Error when parsing area ' + area['idr'] + '.')
            return area
    # end for
    if type(fileName) == type(None):
        fileName = input('Please specify filename (incl extension)')
    
    with open(fileName, 'w', newline='') as oFile:
        writer = csv.writer(oFile, delimiter = ';')
        writer.writerow(['AreaID', 'AreaName', 'base (all)', 'slope (all)', 'base (night)', 'slope (night)', 
                         'base (day)', 'slope (day)'])
        for row in lesigs:
            # Convert all numbers to strings with specific decimal count...
            writer.writerow(row[:2] + ["%.7f" % f for f in row[2:]])
            # print(str(row[:2] + ["%.7f" % f for f in row[2:]]))
    print('Wrote Energy Signature data to ' + fileName + '.')



def ensurePTSNonNeg(pList, vName = 'diff'):
    """Accepts a list of parameter streams 'pList' (or single p).
    Goes through 'diff' in the timeseries 'ts' of each and ensures that no
    values are negative, by subtracting the magnitude of negative values to the
    following positive values (maintains cumulative load).
    This evens out areas with both added and subtracted meters of low 
    resolution, where the subtracted sometimes can tick more than the added 
    for some hours."""
    
    pLoop = [p for p in pList if 'ts' in p.keys()]
    for p in pLoop:
                
        fNeg = False
        v = list(p['ts'][vName]) # List fix to allow int indexing. Should loop over indexes directly intead...
        sNeg = 0 # Memory of unaccounted-for negative values.
        
        for i in range(len(v)):
            if v[i] < 0:
                sNeg += v[i]
                v[i] = 0
                fNeg = True
            elif sNeg > 0:
                # Cancel out against v[i]
                if v[i] > sNeg:
                    v[i] -= sNeg
                    sNeg = 0
                else:
                    sNeg -= v[i]
                    v[i] = 0
            # end if
        # end for
        if fNeg:
            p['ts'][vName] = v
        
        if sNeg > 0:
            print('WARNING: Unaccounted for negative values for p '+p['name'])


def addTSColsToPandas(df, ts, colNames, dateName = 'date', defMiss=np.nan):
    """Adds columns defined by keys "colNames" from iterable timeseries "ts" 
    into pandas dataframe "df", assuming the former has a separate 'date' 
    column and the latter is indexed by date."""
    
    ### THIS CAN ALL BE DONE EASIER WITH PANDAS.INDEX.INTERSECTION! ###
    
    dfd_min = df.index[0]
    dfd_max = df.index[-1]
    tsd_min = ts[dateName][0]
    tsd_max = ts[dateName][-1]
    
    qNaNsPresent = 0
    # Find intersect of min and max
    if dfd_min >= tsd_min:
        # We want this, as it means the entire timeseries will have outT data.
        id_min_insert = df.index[0]   # Where to insert into df
        id_min_cut = ts[dateName].index(df.index[0]) # Where to cut from ts
        # Note that list.index returns index of first match, df.index returns 
        # an array of the values of that dfs index column...
    else:
        id_min_cut = 0
        id_min_insert = ts[dateName][0]
        qNaNsPresent = 1
    
    if dfd_max <= tsd_max:
        # We want this, it means supporting data is longer than meter data
        id_max_insert = df.index[-1]
        id_max_cut = ts[dateName].index(df.index[-1])
    else:
        id_max_cut = -1
        id_max_insert = ts[dateName][-1]
        qNaNsPresent = 1
        
    # Create empty col and add slice.
    # Initiate with NaNs, then overwrite all cells for which we have data.
    for col in colNames:
        df.loc[:,col] = [defMiss]*len(df.index)   # Initiate with NaNs
        newCol = ts[col][id_min_cut:id_max_cut] + [ts[col][id_max_cut]] # Inclusive slice
        
        try:
            df.loc[id_min_insert:id_max_insert, col] = newCol   # Overwrite
        except:
            
            print('Len loc[min:max] = '+str(len(df.loc[id_min_insert:id_max_insert, col]))+'.')
            print('Len newCol = '+str(len(newCol)) +'.')
    
    return qNaNsPresent
    
    # end addTSColsToPandas
    


def strptimeTS(ts, frmt = '%Y-%m-%d %H:%M', dateName='date'):
    """Converts all elements in ts['date'] from string to datetimeObj."""
    
    if hasattr(ts[dateName][0],'join'): # True for string, not for datetime
        # This is really increadibly slow, use list comprehension if needed...
        #for i in range(len(ts[dateName])):
        #    ts[dateName][i] = datetime.datetime.strptime(ts[dateName][i],frmt)
        ts[dateName] = [datetime.datetime.strptime(dat,frmt) for dat in ts[dateName]]






