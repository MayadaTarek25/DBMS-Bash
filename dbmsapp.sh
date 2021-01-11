#!/bin/bash
echo Welcom to DBMS System
mkdir DBMS 2>/dev/null
function mainMenu {
echo MainMenu
echo "1) Create Database"
echo "2) List Database"
echo "3) Connect To Databases"
echo "4) Drop Database"
echo "5) Exit"
echo "Please choose a number of the above Menu"
read
case $REPLY in
        1) createDatabase ;;
        2) listDatabase ;;
        3) connectToDatabase ;;
        4) dropDatabase ;;
        5) exit ;;
	*) wrongMessage1 ;;
esac
}
function createDatabase {
        echo "Please Enter The Name of Database"
        read name
        cd ~/DBMS
        i=0
        for file in `ls`
        do
                if [[ $file == $name ]]
                then
                        i=1
                fi
        done
        if (( i ==  0 ))
        then
                mkdir $name
                echo "===Database $name is created==="
                echo "To (Edit/Add/Remove) in this Database" 
		echo "you can select connectToDatabase in MainMenu........"
		echo "================================="
		sleep 1
                mainMenu
        else
                echo "This name is already exist"
                echo "Do you what to continue?"
                echo "(Y/N)"
                read answer
                if [[ $answer == [Yy] ]]
                then
                        createDatabase
                    else
                        mainMenu
                fi
        fi

}
function listDatabase {
        cd ~/DBMS 
        if [ "$(ls)" ]
        then
                echo "===The Databases that exist in the System is==="
                ls 
		echo "==============================================="
		sleep 1
                mainMenu
        else
                echo "===There isn't Databases on the System yet==="
		sleep 1
                mainMenu
        fi
}
function connectToDatabaseMenu {
	echo "1) Create Table"
        echo "2) List Tables"
        echo "3) Drop Table"
        echo "4) Insert Into Table"
        echo "5) Select From Table"
        echo "6) Delete From Table"
        echo "7) Exit"
        echo "Please choose a number of the above Menu"
        read
        case $REPLY in
	       	1) createTable ;;
                2) listTables ;;
                3) dropTable ;;
                4) insertIntoTable ;;
                5) selectFromTable ;;
                6) deleteFromTable ;;
                7) mainMenu ;;
		*) wrongMessage2 ;;
	esac
}
function dropDatabase {
        echo "Please Enter Database Name"
        read name
        cd ~/DBMS/$name 2>/dev/null
        if [[ $? == 0 ]]
        then
                cd ~/DBMS
                echo "Are you sure you want to remove this $name Database from the System"
                echo "(Y/N)"
                read answer
                if [[ $answer = [Yy] ]]
                then
                        rm -r $name 2>/dev/null
                        if [[ $? == 0 ]]
                        then
                                echo "$name Database is removed successfully"
                                mainMenu
                        else
                                echo "Please Try Again"
                                dropDatabase
                        fi
                elif [[ $answer = [Nn] ]]
                then
                        mainMenu
                else
                        "Please Try Again"
                        dropDatabase
                fi
        else
                echo "This Name doesn't exist"
		sleep 1
                mainMenu
        fi
}
function createTable {
        echo "Please Enter Table Name..."
        read answer
        seperator=","
        name=$answer.csv
        meta=MetaData$answer
        if [[ -f $name ]]
        then
                echo "This Table Name is Already Exist.........."
		sleep 1
                connectToDatabaseMenu
        else
                touch $name
		touch $meta
                echo "Table is created succesfully"
                echo "Please Enter Numbers of Colunms"
                read colnum
                let lastcol=$colnum-1
                echo "MetaData for $answer Table is needed"
                echo "By default first colunm is the primariy key"
                i=0
                line=""
                colindex=1
                                while [ $i -lt $colnum ]
                do
                    echo "Please Enter Colunm $colindex name for $answer Table"
                    read colname

                    if [[ $i == $lastcol ]]
                    then
                         line=$line$colname
                    else
                         line=$line$colname$seperator
                    fi
                    let i=$i+1
                    let colindex=$colindex+1
                done
                echo "---------MetaData for $name Table---------------">>$meta
                echo $name>>$meta
                echo $colnum>>$meta
                echo $line>>$meta
                echo "MetaData is entered succesfully"
        fi
	sleep 1
        connectToDatabaseMenu
}
function insertIntoTable {
        echo "Please Enter Table Name..."
        read answer
        extention=.csv
        seperator=","
        table=$answer$extention
	metatable=MetaData$answer
        if [[ -f $table ]]
        then

                colnum=`head -3 $metatable | tail -1`
		colnames=`head -4 $metatable | tail -1`
		let lastcol=$colnum-1
                echo "Please Enter Numbers of rows you want to insert"
                read rownum
		echo "This is Table has $colnum colunms ($colnames) first colunm is the primary key"
                i=0
                rowindex=1
                while [ $i -lt $rownum ] 
                do      
			colindex=1
                        j=0
                        line1=""
                        echo "Please Enter Row $rowindex Data"
                        while [ $j -lt $colnum ]
                        do
				echo "Enter Data of colunm $colindex" 
                                read rowelem
                                if [[ $j == $lastcol ]]
                                then
                                        line1=$line1$rowelem
                                else
                                        line1=$line1$rowelem$seperator
                                fi
                        let j=$j+1
			let colindex=$colindex+1
                        done
                echo $line1>>$table
                let i=$i+1
                let rowindex=$rowindex+1
                done
                echo "This Data was inserted succesfully"
		sleep 1
	        connectToDatabaseMenu	
        else
                echo "$answer Table isn't exist"
		sleep 1
                connectToDatabaseMenu
        fi
}
function listTables {
        if [ "$(ls)" ]
        then
                echo "===Tables that exist in the System is==="
                ls
		echo "========================================"
		sleep 1
                connectToDatabaseMenu
                else
                echo "There isn't Tables on this Database yet"
		sleep 1
                connectToDatabaseMenu
        fi
}
function dropTable {
        echo "Please Enter Table Name"
        read name
        extention=.csv
        table=$name$extention
        metatable=MetaData$name
        flag=0
	for file in `ls`
	do
		if [[ $file == $table ]]
		then
			let flag=1
		fi
	done
        if [[ $flag == 1 ]]
        then
                echo "Are you sure you want to remove this $name Table from the Database"
                echo "(Y/N)"
                read answer
                if [[ $answer = [Yy] ]]
                then
                        rm $table 
			rm $metatable  
			echo "$name Table is removed successfully"
			connectToDatabaseMenu
                
                elif [[ $answer = [Nn] ]]
                then
                        connectToDatabaseMenu
                else
                        "Please Try Again"
                        dropTable
                fi
        else
                echo "This Name doesn't exist"
		sleep 1
                connectToDatabaseMenu
        fi
}
function selectFromTable {
	echo "Please Enter Table Name..."
        read answer
        extention=.csv
        seperator=","
        table=$answer$extention
        metatable=MetaData$answer
        if [[ -f $table ]]
        then

                colnum=`head -3 $metatable | tail -1`
                colnames=`head -4 $metatable | tail -1`
                echo "This is Table has $colnum colunms ($colnames) first colunm is the primary key"
		echo "please Enter the PK for the row you want to select"
		read PK
		var=$(awk -F, '{ if($1 == "'"$PK"'") {print $0;} }' $table)
		if [[ $var != "" ]]
		then
			showRow $colnum $colnames $var
			sleep 1
			connectToDatabaseMenu
		else
			echo "This PK isn't exist"
			sleep 1
			connectToDatabaseMenu
		fi
        else
                echo "$answer Table isn't exist"
		sleep 1
                connectToDatabaseMenu
        fi
}
function deleteFromTable {
        echo "Please Enter Table Name..."
        read answer
        extention=.csv
        seperator=","
        table=$answer$extention
        metatable=MetaData$answer
        if [[ -f $table ]]
        then

                colnum=`head -3 $metatable | tail -1`
                colnames=`head -4 $metatable | tail -1`
                echo "This is Table has $colnum colunms ($colnames) first colunm is the primary key"
		echo "please Enter the PK for the row  you want to delete"
                read PK
                var=$(awk -F, '{ if($1 == "'"$PK"'") {print $0;} }' $table)
		if [[ $var != "" ]]
		then 
			echo "Are you sure you want to delete this row?"
		        echo "(Y/N)"
		        read answer
		        if [[ $answer = [Yy] ]]
		        then
				sed "/^$PK/d" $table>file.csv
		                cat file.csv>$table
		                rm file.csv
                                echo "This row is deleted succesfully"
				sleep 1
			        connectToDatabaseMenu
                        else
                                connectToDatabaseMenu
                        fi
	        else
			echo "This PK isn't exist"
			sleep 1
			connectToDatabaseMenu
		fi
        else
                echo "$answer Table isn't exist"
		sleep 1
                connectToDatabaseMenu
        fi
}
function showRow() {
	let colnum="$1"+1
	echo "$2">>colnames
	echo "$3">>rowdata
        i=1
	echo ==================Data of this Row====================
	while [ $i -lt $colnum ] 
	do
		var1=$(cut -f$i -d, colnames)
		var2=$(cut -f$i -d, rowdata)
	        echo "  $var1 : $var2"
		let i=$i+1
	        echo ======================================================
	done
	rm colnames
	rm rowdata
}
function connectToDatabase {
	echo "Please Enter Database Name"
        read answer
        cd ~/DBMS/$answer 2>/dev/null
        if [[ $? == 0 ]]
                then
                echo "You select $answer Database........"
                echo Connect TO Database Menu
		connectToDatabaseMenu
        else
                echo "This Database isn't exist"
                echo "Do you what to continue?"
                echo "(Y/N)"
                read answer
                if [[ $answer == [Yy] ]]
                then
                        connectToDatabase
                else
                        mainMenu
                fi

        fi
}
function wrongMessage1 {
	echo "Wrong choice please choose number from this Menu"
	sleep 1
	mainMenu
}
function wrongMessage2 {
        echo "Wrong choice please choose number from this Menu"
	sleep 1
        connectToDatabaseMenu
}
sleep 1
mainMenu

