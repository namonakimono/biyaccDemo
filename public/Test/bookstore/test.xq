(: so when face an expression in CREATE statement, may use this     :)
(: let var in expr to then use galax-run command to get the result. :)

 let $vbook := (<book> 
                  <title>types</title>
                  <price>13.00</price>
               </book>) return
	 <book category="undefined">
           <title >{$vbook/title/text()}</title>
           <author>??</author>
           <year>??</year>
           <price>{$vbook/price/text()}</price>
         </book>
