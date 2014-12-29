/*--------------------------------------------------------------*/
// HTML TABLE SORTER
// OBJECT ORIENTED JAVASCRIPT IMPLEMENTATION OF QUICKSORT
// @author	Terrill Dent 
// @source	http://www.terrill.ca
// @date	August 28th, 2006
/*--------------------------------------------------------------*/
//function TSorter(){
	var table = Object;
	var trs = Array;
	var ths = Array;
	var curSortCol = Object;
	var prevSortCol = '4';
	var sortType = Object;
	var oTH = Object;
	var sType = "";
	var prevTH = Object;
	function get(){}

	function getCell(index){
		var returnv = trs[index].cells[curSortCol];
		return returnv;
	}

	/*----------------------INIT------------------------------------*/
	// Initialize the variable
	// @param tableName - the name of the table to be sorted
	/*--------------------------------------------------------------*/
	//this.init = function(tableName)
	//{
	//	table = document.getElementById(tableName);
	//	ths = table.getElementsByTagName("th");
	//	for(var i = 0; i < ths.length ; i++)
	//	{
	//		ths[i].onclick = function()
	//		{
	//			sort(this);
	//		}
	//	}
	//	return true;
	//};
	
	/*----------------------SORT------------------------------------*/
	// Sorts a particular column. If it has been sorted then call reverse
	// if not, then use quicksort to get it sorted.
	// Sets the arrow direction in the headers.
	// @param oTH - the table header cell (<th>) object that is clicked
	/*--------------------------------------------------------------*/
	function sort(pTH,pType)
	{
		oTH = pTH;
		sType = pType;
		PlayProcess();
		window.setTimeout(Sort2,500);
	}
	function Sort2()
	{
		//ksdflksdfl();
		//alert("StartSort");
		curSortCol = oTH.cellIndex;
		sortType = sType; //oTH.abbr;
		table = oTH.parentElement.parentElement.parentElement;
		ths = table.getElementsByTagName("th");
		trs = table.tBodies[0].getElementsByTagName("tr");
		//set the get function
		setGet(sortType)

		// it would be nice to remove this to save time,
		// but we need to close any rows that have been expanded
		//for(var j=0; j<trs.length; j++)
		//{
		//	if(trs[j].className == 'detail_row')
		//	{
		//		closeDetails(j+2);
		//	}
		//}
		// if already sorted just reverse
	///	alert(prevSortCol + ',' + curSortCol);
		if(prevSortCol == curSortCol)
		{
			oTH.className = (oTH.className != 'ascend' ? 'ascend' : 'descend' );
			reverseTable();
		}
		// not sorted - call quicksort
		else
		{
			//ths[prevSortCol].className = '';
			oTH.className = 'ascend';
			if (prevTH)
			{
				prevTH.className = 'stblh';
			}
			quicksort(0, trs.length);
		}
		prevSortCol = curSortCol;
		prevTH = oTH;
		//alert("Finished");
		StopProcess();
	}
	
	/*--------------------------------------------------------------*/
	// Sets the GET function so that it doesnt need to be 
	// decided on each call to get() a value.
	// @param: colNum - the column number to be sorted
	/*--------------------------------------------------------------*/
	function setGet(sortType)
	{
		switch(sortType)
		{   
			case "link_column":
				get = function(index){
					return  getCell(index).firstChild.firstChild.nodeValue;
				};
				break;
			case "date_column":
				get = function(index){
					var retVal = 0;
					var mCell = getCell(index);
					if (mCell.innerHTML!='')
					{
					var dateVal = mCell.innerHTML;
					var dateEles = dateVal.split("/");
					retVal = dateEles[2] + dateEles[1] + dateEles[0];
					//alert(retVal);
					}
					return retVal;
				};
				break;
			default:
				get = function(index)
				{
					var returnv = getCell(index).firstChild.nodeValue;
					return returnv;
				};
				break;
		};	
	}

	/*-----------------------EXCHANGE-------------------------------*/
	//  A complicated way of exchanging two rows in a table.
	//  Exchanges rows at index i and j
	/*--------------------------------------------------------------*/
	function exchange(i, j)
	{
		if(i == j+1) {
			table.tBodies[0].insertBefore(trs[i], trs[j]);
		} else if(j == i+1) {
			table.tBodies[0].insertBefore(trs[j], trs[i]);
		} else {
			var tmpNode = table.tBodies[0].replaceChild(trs[i], trs[j]);
			if(typeof(trs[i]) == "undefined") {
				table.appendChild(tmpNode);
			} else {
				table.tBodies[0].insertBefore(tmpNode, trs[i]);
			}
		}
	}
	
	/*----------------------REVERSE TABLE----------------------------*/
	//  Reverses a table ordering
	/*--------------------------------------------------------------*/
	function reverseTable()
	{
		for(var i = 1; i<trs.length; i++)
		{
			table.tBodies[0].insertBefore(trs[i], trs[0]);
		}
	}

	/*----------------------QUICKSORT-------------------------------*/
	// This quicksort implementation is a modified version of this tutorial: 
	// http://www.the-art-of-web.com/javascript/quicksort/
	// @param: lo - the low index of the array to sort
	// @param: hi - the high index of the array to sort
	/*--------------------------------------------------------------*/
	function quicksort(lo, hi)
	{
		if(hi <= lo+1) return;
		 
		if((hi - lo) == 2) {
			if(get(hi-1) > get(lo)) exchange(hi-1, lo);
			return;
		}
		
		var i = lo + 1;
		var j = hi - 1;
		
		if(get(lo) > get(i)) exchange(i, lo);
		if(get(j) > get(lo)) exchange(lo, j);
		if(get(lo) > get(i)) exchange(i, lo);
		
		var pivot = get(lo);
		
		while(true) {
			j--;
			while(pivot > get(j)) j--;
			i++;
			while(get(i) > pivot) i++;
			if(j <= i) break;
			exchange(i, j);
		}
		exchange(lo, j);
		
		if((j-lo) < (hi-j)) {
			quicksort(lo, j);
			quicksort(j+1, hi);
		} else {
			quicksort(j+1, hi);
			quicksort(lo, j);
		}
	}
//}
function Toggle(node)
{
	// Unfold the branch if it isn't visible
	if (node.nextSibling.style.display == 'none')
	{
		// Change the image (if there is an image)
		if (node.childNodes.length > 0)
		{
			if (node.childNodes.item(0).nodeName == "IMG")
			{
				node.childNodes.item(0).src = "../images/minus.gif";
			}
		}

		node.nextSibling.style.display = 'block';
	}
	// Collapse the branch if it IS visible
	else
	{
		// Change the image (if there is an image)
		if (node.childNodes.length > 0)
		{
			if (node.childNodes.item(0).nodeName == "IMG")
			{
				node.childNodes.item(0).src = "../images/plus.gif";
			}
		}

		node.nextSibling.style.display = 'none';
	}
}

