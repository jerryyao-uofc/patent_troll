
libname source 'C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project';

proc import datafile = 'C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/stanford_patent_litigation.csv'
	out = sued_patents
	dbms = CSV
	;
run;

data patents;
	set sued_patents;
	do i = 1 to countw(Alleged_Infringer,';');
		Infringer = compress(scan(Alleged_Infringer,i,';'),'""');
		Infringer = tranwrd(Infringer,".com","");
		Infringer = compress(Infringer,'.,');
		Infringer = propcase(Infringer);
		Infringer = tranwrd(Infringer," Llc ","");
		Infringer = tranwrd(Infringer," Incorporated ","");
		Infringer = tranwrd(Infringer," Inc ","");
		Infringer = tranwrd(Infringer," Co ","");
		Infringer = tranwrd(Infringer," Holdings ","");
		Infringer = tranwrd(Infringer," Ho ","");
		Infringer = tranwrd(Infringer," Corporation ","");
		Infringer = tranwrd(Infringer," Corp ","");
		Infringer = tranwrd(Infringer," Company ","");
		Infringer = tranwrd(Infringer," Hldg ","");
		Infringer = tranwrd(Infringer," Ent ","");
		Infringer = tranwrd(Infringer," Ltd ","");
		Infringer = tranwrd(Infringer," Association ","");
		Infringer = tranwrd(Infringer," Foundation ","");
		Infringer = tranwrd(Infringer," Club ","");
		Infringer = tranwrd(Infringer," Fund ","");
		Infringer = tranwrd(Infringer," The ","");
		Infringer = tranwrd(Infringer," And ","");
		Infringer = tranwrd(Infringer," Of ","");
		Infringer = tranwrd(Infringer," Services ","");
		Infringer = tranwrd(Infringer," Enterprises ","");
		Infringer = strip(Infringer);
		OUTPUT;
	end;
run;

data sued;
	set patents;
	if not missing(Infringer);
	if not missing(Asserter_Category);
	keep case_node_id Filing_Date Infringer asserter_id Asserter_Category troll_count sued_count;
run;

proc sort data=sued;
	by Infringer case_node_id Filing_Date Asserter_Category;
run;

data source.stanford;
	length troll_count 5 sued_count 5;
	set sued;
	by Infringer case_node_id Filing_Date Asserter_Category;
	if first.case_node_id;
	retain troll_count sued_count;
	if first.Infringer then do;
		troll_count = 0;
		sued_count = 0;
	end;
	if Asserter_Category < 3
		then troll_count=troll_count + 1;
	sued_count=sued_count+1;
run;

proc export data=source.stanford
    outfile='C:/Users/James Zhou/Documents/UChicago/Third Year/ECMA31320/Project/stanford_counts.csv'
    dbms=csv;
run;
