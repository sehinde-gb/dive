Class sehinde.Advent2021.Day4 Extends sehinde.Advent2021.Base
{

/// Description
ClassMethod PartOne(dir As %String = "/usr/local/2021-4.txt") As %Status
{
   // Open the text file and check it exists
    If ##class(%File).Exists(dir) '=1 {
        write !, "Unable to Open: "_dir

        QUIT

    }ELSE { 
        write "File: "_dir_" is open"

    }

    // instantiate a new class called file
    set stream = ##class(%Stream.FileCharacter).%New()
    // create a new variable called sc
    set sc = stream.LinkToFile(dir)
    
 
	While 'stream.AtEnd {
		
		set record=stream.ReadLine()
		//write record,!
        set line = $INCREMENT(line)
        set recordsArr(line)=record
        //write recordsArr(line),!
	}

    

	set DrawnNumbers=..GetData(.recordsArr,.Boards)
    write "Drawn numbers:",DrawnNumbers,!
	set Answer=""
	for pos=1:1:$length(DrawnNumbers,",") {
        // Extract each number with comma as delimiter and assign to drawnnumber
		set DrawnNumber=$piece(DrawnNumbers,",",pos)
        //write DrawnNumber,!
        // pass the drawn number and the boards to the markboard method
		do ..MarkBoards(.Boards,DrawnNumber)

		set Board="",WinningBoard="",SW=0
		for  {
            // order each board
			set Board=$order(Boards(Board)) quit:Board=""
            // assign the winning board to the sw variable
			set SW=..IsWinningBoard(.Boards,Board)
			if SW {
				set WinningBoard=Board
				quit
			}
		}
		quit:SW
	}
    
	set Sum=..BoardSum(.Boards,WinningBoard)
    write !,"Sum=",Sum,", DrawnNumber=",DrawnNumber
	set Answer=DrawnNumber*Sum
    write "Answer",Answer,! 
	quit Answer
}

ClassMethod GetData(ByRef RecordsArr, Output Boards) As %String [ Private ]
{
	set Line="",Board=0,DrawnNumbers=""
	for {
        // work out how many lines there are within the array
		set Line=$order(RecordsArr(Line)) quit:Line=""
        //write Line,!
        // assign the lines to each record
		set Record=RecordsArr(Line)
        //write Record,! 
        // if there are spaces add a line and continue
		if '$length(Record) {
			set Board=Board+1
			continue
		}
        // if there is a comma set this to the drawn number
		if Record["," {
			set DrawnNumbers=Record
            //write DrawnNumbers,!
			continue
		}
        // count the boards and assign 5 lines to a board
		set BoardLine=$increment(Boards(Board)),BoardNumbers=""
        //write BoardLine,!
		for loc=1:3:$length(Record) {
            // extract each record and remove white spaces and concatenate to the boardnumbers
			set BoardNumbers=BoardNumbers_$lb($lb(+$zstrip($extract(Record,loc,loc+2),"<>W"),0))
            //write BoardNumbers,!
		}
		set Boards(Board,BoardLine)=BoardNumbers
        //write Boards(Board,BoardLine),!
	}
	set Board=""
	for  {
		set Board=$order(Boards(Board)) quit:Board=""
		set Boards(Board)=0
	}

    
	quit DrawnNumbers
}

ClassMethod MarkBoards(ByRef Boards, DrawnNumber) As %Boolean [ Private ]
{
	set Board="",SW=0
	for  {
        // order the boards and loop through the boards
		set Board=$order(Boards(Board)) quit:Board=""
		continue:Boards(Board)
		set SW=1
		for Row=1:1:5 {
            // pull out each rown on the board and assign to rowData
			set RowData=Boards(Board,Row)
            //write RowData,!
			for Column=1:1:5 {
                // create a list from rowdata and columns and set this to numberdata
				set NumberData=$list(RowData,Column)
                //write NumberData,!
                // compare each row against the drawn number
				if $list(NumberData,1)=DrawnNumber {
                    // set the lists and numberdata
					set $list(NumberData,2)=1
					set $list(RowData,Column)=NumberData
					set Boards(Board,Row)=RowData
				}
			}
		}
	}
	quit SW
}

ClassMethod IsWinningBoard(ByRef Boards, Board) As %Boolean [ Private ]
{
	set SW=0
	for Row=1:1:5 {
		set RowData=Boards(Board,Row)
		set SW=1
		for Column=1:1:5 {
			set NumberData=$list(RowData,Column)
			if $list(NumberData,2)=0 {
				set SW=0
				quit
			}
		}
		quit:SW
	}
	quit:SW 1
	for Column=1:1:5 {
		set SW=1
		for Row=1:1:5 {
			set RowData=Boards(Board,Row)
			set NumberData=$list(RowData,Column)
			if $list(NumberData,2)=0 {
				set SW=0
				quit
			}
		}
		quit:SW
	}
	quit SW
}

ClassMethod BoardSum(ByRef Boards, Board) As %Integer [ Private ]
{
	set Sum=0
	for Row=1:1:5 {
		set RowData=Boards(Board,Row)
		for Column=1:1:5 {
			set NumberData=$list(RowData,Column)
			if $list(NumberData,2)=0 {
				set Sum=Sum+$list(NumberData,1)
			}
		}
	}
	quit Sum
}

}