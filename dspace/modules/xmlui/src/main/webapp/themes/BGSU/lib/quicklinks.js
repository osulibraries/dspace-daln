
function BGSU_jumpMenu(targ,selObj,restore) {
 var option = selObj.options[selObj.selectedIndex];
 if (option.getAttribute('target')!='_blank') {
  eval(targ+'.location=\''+selObj.options[selObj.selectedIndex].value+'\'');
  if (restore) selObj.selectedIndex=0;
 } else {
  window.open(selObj.options[selObj.selectedIndex].value,'blank','');
 }
}

document.writeln('<select class="search_new" name="quicklinks" height="16" width="100" vspace="0" hspace="0" border="0" align="top" onChange="BGSU_jumpMenu(\'parent\',this,1)">');
document.writeln(' <option selected="" value="#">Quick Links...</option>');

document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="#">HOT LINKS</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/admissions/choose/aboutbg/">&nbsp;&nbsp;  About BGSU</option>');

document.writeln(' <option value="http://www.bgsu.edu/">&nbsp;&nbsp;  BGSU Home</option>');

document.writeln(' <option value="http://calendar.bgsu.edu">&nbsp;&nbsp;  Calendar of Events</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/pr/campusupdate/page13966.html">&nbsp;&nbsp;  Campus Update Form</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/reslife/place2be/">&nbsp;&nbsp;  Conference Programs</option>');

document.writeln(' <option value="http://www.bgsu.edu/scripts/contact.html">&nbsp;&nbsp;  Contact Us</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/ir/page17047.html">&nbsp;&nbsp;  Mission Statement</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/mc/news/2007/">&nbsp;&nbsp;  News</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/bursar/page25675.html">&nbsp;&nbsp;  Pay Bills Online</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/president/pointofview/">&nbsp;&nbsp;  Point of View</option>');

document.writeln(' <option value="http://www.bgsu.edu/studentinsurance">&nbsp;&nbsp;  Student Insurance</option>');


document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/search.html">SEARCH</option>');

document.writeln(' <option value="http://www.bgsu.edu/people_search.html">&nbsp;&nbsp;  Search People</option>');

document.writeln(' <option value="http://www.bgsu.edu/web_search.html">&nbsp;&nbsp;  Search Web</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/academics/index.html">ACADEMICS</option>');

document.writeln(' <option value="http://calendar.bgsu.edu//MasterCalendar.aspx?data=zF4djibTi3wWN%2f222i5VFw%3d%3d">&nbsp;&nbsp;  Academic Calendar</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/acen/">&nbsp;&nbsp;  Academic Enhancement</option>');

document.writeln(' <option value="http://adultlearnerservices.bgsu.edu/">&nbsp;&nbsp;  Adult Learners Services & Evening Credit</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/advising/">&nbsp;&nbsp;  BGSU Academic Advising</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/gradcol/page24974.html">&nbsp;&nbsp;  Catalog-Graduate</option>');

document.writeln(' <option value="http://www.bgsu.edu/catalog">&nbsp;&nbsp;  Catalog-Undergraduate</option>');

document.writeln(' <option value="http://www.firelands.bgsu.edu/">&nbsp;&nbsp;  College - Firelands</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/gradcol/">&nbsp;&nbsp;  College - Graduate</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/as/">&nbsp;&nbsp;  College of Arts and Sciences</option>');

document.writeln(' <option value="http://www.cba.bgsu.edu/cba/index.html">&nbsp;&nbsp;  College of Business Administration</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/edhd/">&nbsp;&nbsp;  College of Education & Human Development</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/hhs/">&nbsp;&nbsp;  College of Health & Human Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/music/index.html">&nbsp;&nbsp;  College of Musical Arts</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/technology/index.html">&nbsp;&nbsp;  College of Technology</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/">&nbsp;&nbsp;  Colleges</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/life/commencement/">&nbsp;&nbsp;  Commencement</option>');

document.writeln(' <option value="http://cee.bgsu.edu">&nbsp;&nbsp;  Continuing & Extended Education</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/mc/news/page6097.html">&nbsp;&nbsp;  Cooperative Education</option>');

document.writeln(' <option value="http://webapps.bgsu.edu/courses/search.php">&nbsp;&nbsp;  Course Descriptions</option>');

document.writeln(' <option value="http://ideal.bgsu.edu/">&nbsp;&nbsp;  Distance Learning (IDEAL)</option>');

document.writeln(' <option value="http://educationabroad.bgsu.edu">&nbsp;&nbsp;  Education Abroad</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/honors/">&nbsp;&nbsp;  Honors Program</option>');

document.writeln(' <option value="http://international.bgsu.edu">&nbsp;&nbsp;  International Programs</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/career/page20308.html">&nbsp;&nbsp;  Internship Program</option>');

document.writeln(' <option value="http://www.bgsu.edu/departments/greal/llc/frameset.htm">&nbsp;&nbsp;  Language Learning Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/colleges/library/">&nbsp;&nbsp;  Libraries</option>');

document.writeln(' <option value="http://go2.bgsu.edu/choose/academics/majors/">&nbsp;&nbsp;  Majors</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/acen/mastctr/">&nbsp;&nbsp;  Math and Stats Tutoring Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/achievement/index.htm">&nbsp;&nbsp;  Office of Student Academic Achievement</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/provost/">&nbsp;&nbsp;  Office of the Provost</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/provost/centers.htm">&nbsp;&nbsp;  Research Centers</option>');

document.writeln(' <option value="http://webapps.bgsu.edu/classes/search.php">&nbsp;&nbsp;  Schedule of Classes</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/acen/studyskillsctr/">&nbsp;&nbsp;  Study Skills Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/acen/writingctr/">&nbsp;&nbsp;  Writing Center</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="#">ADMISSIONS</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/admissions/choose/apply.html">&nbsp;&nbsp;  Apply Now</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/counseling/Testing.htm">&nbsp;&nbsp;  College Entrance Exams</option>');

document.writeln(' <option value="http://admissnt1.bgsu.edu/request/info.php">&nbsp;&nbsp;  Request Information</option>');

document.writeln(' <option value="http://admissnt1.bgsu.edu/visitbg/">&nbsp;&nbsp;  Schedule a Visit</option>');

document.writeln(' <option value="http://admissnt1.bgsu.edu/offices/admissions/choose/transfer.html">&nbsp;&nbsp;  Transfer Students</option>');

document.writeln(' <option value="http://admissnt1.bgsu.edu/offices/admissions/choose/tour1.html">&nbsp;&nbsp;  Virtual Tour</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/alumni_guests/index.html">ALUMNI &amp; GUESTS</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/alumni">&nbsp;&nbsp;  Alumni Association</option>');

document.writeln(' <option value="http://www.alumniconnections.com/olc/pub/BGU/directory.html">&nbsp;&nbsp;  Alumni Directory</option>');

document.writeln(' <option value="http://www.alumniconnections.com/olc/pub/BGU">&nbsp;&nbsp;  BGSU Online Community</option>');


document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://bgsufalcons.collegesports.com/">ATHLETICS</option>');

document.writeln(' <option value="http://bgsufalcons.ocsn.com/store/bgu-store.html">&nbsp;&nbsp;  Falcon FANStore</option>');

document.writeln(' <option value="http://bgsufalcons.ocsn.com/calendar/bgu-calendar.html">&nbsp;&nbsp;  Schedules</option>');

document.writeln(' <option value="http://bgsufalcons.ocsn.com/tickets/bgu-tickets.html">&nbsp;&nbsp;  Tickets</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/map/">CAMPUS MAP</option>');

document.writeln(' <option value="http://www.bgsu.edu/map/page23944.html">&nbsp;&nbsp;  Driving Directions to BGSU</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/faculty_staff/index.html">FACULTY &amp; STAFF</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/index.html">&nbsp;&nbsp;  Administrative Offices</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/cio/page838.html">&nbsp;&nbsp;  BG@100</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/advising/">&nbsp;&nbsp;  BGSU Academic Advising</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/execvp/index.html">&nbsp;&nbsp;  Executive Vice President</option>');

document.writeln(' <option value="http://www.bgsu.edu/faculty_staff/forms/">&nbsp;&nbsp;  Forms</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/mc/gsm/">&nbsp;&nbsp;  Graphic Standards Manual</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/ohr">&nbsp;&nbsp;  Human Resources</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/ohr/employment/">&nbsp;&nbsp;  Jobs at BGSU</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/president/index.html">&nbsp;&nbsp;  Office of the President</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/provost/">&nbsp;&nbsp;  Office of the Provost</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/health/pharmacy/">&nbsp;&nbsp;  Pharmacy</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/mc/monitor/">&nbsp;&nbsp;  The Monitor</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/ohr/training/">&nbsp;&nbsp;  Training</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/mc/gsm/page15013.html">&nbsp;&nbsp;  University Stationery</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/vp/index.html">&nbsp;&nbsp;  Vice-President Student Affairs</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://giving.bgsu.edu/development/fundingopps">GIVING TO BGSU</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/alumni/give/page35336.html">&nbsp;&nbsp;  Online Giving</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/parents/index.html">PARENTS &amp; FAMILY</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/offices/sa/life/">STUDENT LIFE</option>');

document.writeln(' <option value="http://www.bg24news.com/">&nbsp;&nbsp;  BG 24 News</option>');

document.writeln(' <option value="http://www.bgsu.edu/students/bgexperience/">&nbsp;&nbsp;  BGeXperience Program</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/president/page11661.html">&nbsp;&nbsp;  Code of Ethics & Conduct</option>');

document.writeln(' <option value="http://www.bgsu.edu/studentlife/organizations/gss/index.html">&nbsp;&nbsp;  Graduate Student Senate</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/greekaffairs/index.html">&nbsp;&nbsp;  Greek Organizations</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/reslife/">&nbsp;&nbsp;  Housing/Meal Sign-up</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/recsports/intramurals/">&nbsp;&nbsp;  Intramurals</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/cmai/">&nbsp;&nbsp;  Multicultural Programs</option>');

document.writeln(' <option value="http://off-campus.bgsu.edu">&nbsp;&nbsp;  Off-Campus Programs</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/offcampus/">&nbsp;&nbsp;  Off-Campus Student Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/firstyear/">&nbsp;&nbsp;  Orientation & First-Year Programs</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/recsports/">&nbsp;&nbsp;  Recreational Sports</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/reslife/">&nbsp;&nbsp;  Residence Life</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/getinvolved/page12173.html">&nbsp;&nbsp;  Student Organizations</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/pub/">&nbsp;&nbsp;  Student Publications</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/union/">&nbsp;&nbsp;  Student Union</option>');

document.writeln(' <option value="http://www.bgnews.com/">&nbsp;&nbsp;  The BG News (Campus Newspaper)</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/studentgovernment/usg/index.html">&nbsp;&nbsp;  Undergraduate Student Government</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/vp/index.html">&nbsp;&nbsp;  Vice-President Student Affairs</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="#">STUDENT SERVICES</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/advising/">&nbsp;&nbsp;  BGSU Academic Advising</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/bookstore/">&nbsp;&nbsp;  Bookstore</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/bursar/">&nbsp;&nbsp;  Bursar (Fees)</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/safety/page25629.html">&nbsp;&nbsp;  Campus Escort Service</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/career">&nbsp;&nbsp;  Career Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/counseling/">&nbsp;&nbsp;  Counseling Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/dining/">&nbsp;&nbsp;  Dining Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/disability/">&nbsp;&nbsp;  Disability Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/departments/esl/">&nbsp;&nbsp;  English as a Second Language Program</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sfa/">&nbsp;&nbsp;  Financial Aid</option>');

document.writeln(' <option value="http://www.bgsu.edu/departments/gradstep/">&nbsp;&nbsp;  GradSTEP</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/health/">&nbsp;&nbsp;  Health Services</option>');

document.writeln(' <option value="https://my.bgsu.edu/">&nbsp;&nbsp;  MyBGSU</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/career/page19878.html">&nbsp;&nbsp;  On-Campus Student Employment</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/safety/">&nbsp;&nbsp;  Parking & Traffic</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sa/health/pharmacy/">&nbsp;&nbsp;  Pharmacy</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/materials/page22559.html">&nbsp;&nbsp;  Postal Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/registrar/">&nbsp;&nbsp;  Registration and Records</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/safety/parking/shuttle.html">&nbsp;&nbsp;  Shuttle Service</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/sls">&nbsp;&nbsp;  Student Legal Services</option>');

document.writeln(' <option value="http://www.bgsu.edu/studenttech/">&nbsp;&nbsp;  Student Technology Center</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/registrar/page5601.html">&nbsp;&nbsp;  Transcripts</option>');

document.writeln(' <option value="https://webmail.bgsu.edu/">&nbsp;&nbsp;  WebMail</option>');



document.writeln(' <option value="#">--------------------------------------------------------------------------</option>');
document.writeln(' <option value="http://www.bgsu.edu/its/">TECHNOLOGY</option>');

document.writeln(' <option value="http://www.bgsu.edu/its/labs/index.html">&nbsp;&nbsp;  Computer Labs</option>');

document.writeln(' <option value="http://www.bgsu.edu/its/software/page9928.html">&nbsp;&nbsp;  Email</option>');

document.writeln(' <option value="http://www.bgsu.edu/offices/cio/webdev/index.html">&nbsp;&nbsp;  Office of Web Development</option>');

document.writeln(' <option value="http://www.bgsu.edu/its/tsc/index.html">&nbsp;&nbsp;  Tech Support Center</option>');



document.writeln('</select>');
 