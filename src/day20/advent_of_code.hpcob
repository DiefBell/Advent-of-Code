$set sourceformat(free)

IDENTIFICATION DIVISION.
PROGRAM-ID. AdventOfCode.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT InputFile ASSIGN TO './input.txt'
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD InputFile.
01 InputRecord PIC X(128). *> Each line is up to 128 characters.

WORKING-STORAGE SECTION.
01 WS-EOF            PIC X VALUE 'N'.
01 WS-LineNumber     PIC 9(4) VALUE 0.
01 LOOP-NumIndex     PIC 9(4) VALUE 0. *> Separate loop variable
01 EFFECTIVE-INDEX   PIC 9(8).
01 WS-2DArray.
    05 WS-SubArray OCCURS 1024 TIMES INDEXED BY IDX PIC X(128).  *> Store each line as a string

01 WS-ParseArea.
    05 WS-BeforeColon   PIC 9(16). *> Handles up to 16 digits before the colon.
    05 WS-AfterColon    PIC X(111). *> After colon, up to 111 characters (128 - colon and spaces).

01 WS-Token PIC X(17). *> Handles up to 16 digits plus a null terminator for safety.
01 WS-NumIndex PIC 99 VALUE 1.

PROCEDURE DIVISION.
	OPEN INPUT InputFile
	PERFORM UNTIL WS-EOF = 'Y'
        READ InputFile INTO InputRecord
            AT END
                MOVE 'Y' TO WS-EOF
            NOT AT END
                ADD 1 TO WS-LineNumber
                *> Store the current input line into the array (at WS-LineNumber).
				MOVE InputRecord TO WS-SubArray(WS-LineNumber)
        END-READ
    END-PERFORM
    CLOSE InputFile

    PERFORM VARYING WS-LineNumber FROM 1 BY 1 UNTIL WS-LineNumber > 1024
        PERFORM VARYING LOOP-NumIndex FROM 1 BY 1 UNTIL LOOP-NumIndex > 128
            COMPUTE EFFECTIVE-INDEX = (WS-LineNumber - 1) * 128 + LOOP-NumIndex
            IF WS-SubArray(EFFECTIVE-INDEX) NOT = 0
                DISPLAY WS-SubArray(EFFECTIVE-INDEX)
            END-IF
        END-PERFORM
    END-PERFORM.

