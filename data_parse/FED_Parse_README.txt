### INSTRUCTIONS FOR FED-DATA PARSE & CONVERSION SCRIPTS ###
Author: Jens Carlsson, Utilifeed AB
jens@utilifeed.com, tel (+46)739333463

1) REQUIREMENTS
Python 3.5+ with the following packages:
xlrd, numpy, pandas, (alt: statsmodels, matplotlib)
Jupyter Notebook 4.2+

For windows, these are easiest installed together as part of Continuum's "Anaconda" distribution
None of the included scripts have been tested in a Windows/MacOS environment, breakage is very possible. For example os.path.join() is used for all file paths to avoid path errors, but if other errors pop up please contact the author.

To "install", put all .py and .ipynb files in the same directory, which also contains the "data" directory as a folder. All .txt files in 'data' (including subfolders) will be parsed as AH timeseries files, do not put any other .txt files in this directory. Other files should be placed according to source:
- E-rapport in data/ERapport_CFAB (even if they don't belong to cfab), 
- Landlord files in data/Landlord,
- Metry files in data/Metry.

2) PREAMBLE & STRUCTURE
These python scripts were initially intended to be a short script for parsing all text files from Academiska Hus and convert these into JSON for further analysis. As the required tasks evolved new functionality was bolted onto already existing scripts, and due to the short timeframe no efforts were made to reformat old code into ways that made more sense with the new requirements and funcionality. As such the codebase is now quite messy, and rather than do an extensive code rewrite I'll create a set of (hopefully) easily understandable jupyter notebook cells to do common tasks. Relevant file structure is as follows:
dc.py - Home of class BColl, which parses .txt files from AH and saves them as json
dc2.py - Home of class PColl, which has an internal structure slightly different from BColl. Expects to be initiated from a flat json created by dc.BColl, then has methods for adding landlord, e-rapport and metry files to this.
dc2u.py - Home of several functions that can act either on the collection of parameter streams in a dc2.PColl object, or the series of 'p's in an area list.
FED.Parse.tasks.ipynb - Notebook containing scripts for use with running a series of functions/methods from the above files to produce a desired result

3) FILE NAMING AND FORMATTING CONVENTIONS
3.1) AH .txt files 
    No naming convention, the name isn't parsed.
    Files are stored according to buildingID, meterID and meterType (medium), read from rows 1-4 in the file. Including multiple files that share these attributes will likely result in only the last parsed being kept, though parser may also crash...
3.2) E-rapport files
    Files are downloaded through the feature 'Rapporter -> timavläsning, lista'
    Choose period of 1 year, and download the full year
    Naming convention: UFOid-buildingName-meterID-year.xls
        meterID must begin with el_, fj_ or kb_
        Filename may not contain any other dashes
        Make one separate file per year (this is the only way I managed to download the data)
    Script will only parse meters for which -2015.xls exists, minor edits to the code would have to be done so it instead searches for -2016 and prepends 2015 if you want to use buildings for which 2015 has no data.
3.3) Landload files
    If any questions regarding download, ask Johan Kensby
    Only one file per meter
    Naming convention: UFOid-buildingName-meterID.xlsx
    Again, no extra dashes allowed in name and meterID must begin with el_, fj_ or kb_
3.4) Metry files
    Download meter monthly data into .xls
    Naming convention: UFOid-buildingName-meterID-startDate-endDate.xls
        dates as 'YYYYMMDD', no separators
    Otherwise, same rules as above

4) NOTEBOOK TASKS
A number of cells for logically separated tasks are included in the jupyter notebook FED_Parse_notebook.ipynb
Some tasks require that you run multiple of these cells.

4.1) Add meters and/or update area definitions
    1- Add all files to the 'data' folder, following instructions in 3.X). If you're not adding any new files and have already completed steps 1-3 at least once, you may skip immediately to step 4.
    2- Run cell 1 to create flat json based on all AH txt files. This is NOT NECESSARY if flat json already exists in directory (downloaded from dropbox or if you've ran this cell before) and you haven't added any new AH txt files.
    3- Run cell 2 to load the flat json into object 'b' (of class dc2.PColl), then parse all files from Metry, Landlord and E-rapport. Also saves object 'b' into 'PColl_b.pkl'. Skip step 4 if you did this (it doesn't do anything).
    4- Run cell 3 to load object 'b' into memory from 'PColl_b.pkl'
    5- If you added any new files (from any source), update the area lists (aFj, aEl and/or aKb) in cell 4 to make the new meters part of the output. The integer/float at the end of each meter reference is a factor by which each hourly value from that meter is multiplied before being added to the area (so 1 means it's just included, while -0.1 means a tenth of it is subtracted from the area). Other than that the format is supposed to be self-documenting, but if you have any questions please contact the author.
    6- Run cell 4 to define area lists and incorporate data from 'b' into them. Arealists with attached timeseries data are now in memory as 'aFj', 'aEl' and 'aKb'

4.2) Update csv according to new area definitions:    
    1- Complete steps 1 through 6 in 4.1
    2- Run cell 5 to consolidate all areas into a single dataframe (one per area list) and write it as a csv.

4.2) Update energy signature data
    1- Complete steps 1 through 6 in 4.1
    2- Run cell 4
    
4.3) Create new summary illustrations for an area list
    1- Complete steps 1 through 6 in 4.1
    2- Run cell 6



