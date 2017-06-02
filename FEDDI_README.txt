I place the data import script I used here while I wait for access to dropbox.
Instructions to generate unified .json with all meter series:
- Make sure you have python 3.4+ with numpy installed
    - numpy is only used for linear interpolation, can be rewritten if required
- Load the module into and set wd to the parent of the FED "data/" folder
    - Easiest way to do this is to put FEDDI.py into the directory containing 
    the "data" folder, cd into that folder via command line, launching the 
    inline python interpreter and typing "import FEDDI"
- Exectute the following python commands (type into command line) in order:
    - bData = FEDDI.BColl(parse=True)
        - This will take a little while, during which you see output of how 
        each file is processed
    - bData.writeFlatDict(fileName = 'allData_flat.json')
        - This creates a .json with all processed raw data and 
        interpolated timeseries. Each data-stream is named "p1" through "p154"
        - Information regarding that stream is stored in:
            'parameterNumber', 'tsRaw', 'fractionMissing', 'parameterName', 
            'ts', 'parameterType', 'unit', 'accessPath', 'meterName', 'log', 
            'buildingName', 'fileName'
        - 'tsRaw' contains the (processed) raw timeseries (date,value)
        - 'ts' contains the interpolated timeseries with one value per hour
        as (date, state, diff), where 'state' is the interpolated meter state 
        and diff (where applicable) is the hourly diff.
- To remove data before writing as .json (for compactness), type 
"bData.deleteRawTS()" to delete the raw timeserieses before writing, or use 
bData.deleteIfNot([look at line 446 for details]) to filter certain types of
dataserieses.
- For questions, contact jens@utilifeed.com
