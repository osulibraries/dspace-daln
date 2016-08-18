/*
 * KRG OhioLINK
 * This file contains code to make suckerfish
 * drop down menus work in IE6.
 *
 * Reference http://www.htmldog.com/articles/suckerfish/dropdowns/
 * Accessed 01/15/2008
 */
 
 sfHover = function() {
   var sfEls = document.getElementById("topdropmenu").getElementsByTagName("LI");
   for (var i=0; i<sfEls.length; i++)
   {
      sfEls[i].onmouseover=
      function()
      {
         this.className+=" sfhover";
      }
      sfEls[i].onmouseout=
      function()
      {
          this.className=this.className.replace(new RegExp(" sfhover\\b"),"");
      }
   }
 }
 
 if (window.attachEvent) window.attachEvent("onload",sfHover);
 