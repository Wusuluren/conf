
macro Hwave_getBlankIdx(str)
{
	len = StrLen(str)
	idx = 0
	while (idx < len) {
	    ch = StrMid(str, idx, idx+1)
	    if ((ch != "\t") && (ch != " ")) {
	    	break
	    }
		idx = idx + 1
	}	 
	return idx
}

macro Hwave_getBlankPrefix(str)
{
	len = StrLen(str)
	idx = 0
	prefix = ""
	while (idx < len) {
	    ch = StrMid(str, idx, idx+1)
	    if ((ch != "\t") && (ch != " ")) {
	    	break
	    }
		prefix = Cat(prefix, ch)
		idx = idx + 1
	}	 
	return prefix
}

macro Hwave_getBlankRecord(str)
{
	len = StrLen(str)
	idx = 0
	prefix = ""
	while (idx < len) {
	    ch = StrMid(str, idx, idx+1)
	    if ((ch != "\t") && (ch != " ")) {
	    	break
	    }
		prefix = Cat(prefix, ch)
		idx = idx + 1
	}	 
	record = nil
	record.prefix = prefix
	record.idx = idx
	return record
}

//Key Assignments: Ctrl + /
macro Hwave_MultiLineComment()
{
	hwnd = GetCurrentWnd()
	LnFirst = GetWndSelLnFirst(hwnd)
	LnLast = GetWndSelLnLast(hwnd)
	hbuf = GetCurrentBuf()

	if(GetBufLine(hbuf, 0) == "//magic-number:tph85666031") {
        stop
    }

    //find do comment or uncomment
    doComment = True
    Ln = LnFirst
	while (Ln <= LnLast) {
		buf = GetBufLine(hbuf, Ln)
    	len = StrLen(buf)
    	if (len == 0) {
    		Ln = Ln + 1
    		continue
    	}
		idx = Hwave_getBlankIdx(buf)	
    	if (idx+2 <= len) {
	    	if (StrMid(buf, idx, idx+2) == "//") {
	    		doComment = False
	    	}
    	} 
    	if (!doComment) {
    		break
    	}
   		Ln = Ln + 1
    }

	if (doComment) {
		//step 1
		commentBeginIdx = 10000
		commentBeginPrefix = ""
		Ln = LnFirst
		while (Ln <= LnLast) {
			buf = GetBufLine(hbuf, Ln)
	    	len = StrLen(buf)
	    	if (len == 0) {
	    		Ln = Ln + 1
	    		continue
	    	}
			record = Hwave_getBlankRecord(buf)
			prefix = record.prefix
			idx = record.idx	
			if (idx < commentBeginIdx) {
    			commentBeginIdx = idx
    			commentBeginPrefix = prefix
    		}	
	   		Ln = Ln + 1
		}

		//step 2
	    Ln = LnFirst
	    while (Ln <= LnLast) {
	    	buf = GetBufLine(hbuf, Ln)
	    	len = StrLen(buf)
			if (commentBeginIdx < len) {
				PutBufLine(hbuf, Ln, Cat(commentBeginPrefix, Cat("//", StrMid(buf, commentBeginIdx, len))))
			} else {
	    		PutBufLine(hbuf, Ln, Cat(commentBeginPrefix, "//"))
	    	}
	    	Ln = Ln + 1
	    }
	} else {
	    Ln = LnFirst
	    while (Ln <= LnLast) {
	    	buf = GetBufLine(hbuf, Ln)
	    	len = StrLen(buf)
			record = Hwave_getBlankRecord(buf)
			prefix = record.prefix
			idx = record.idx	
	    	if (idx+2 <= len) {
		    	if (StrMid(buf, idx, idx+2) == "//") {
		    		PutBufLine(hbuf, Ln, Cat(prefix, StrMid(buf, idx+2, len)))
		    	}
	    	}
	    	Ln = Ln + 1
	    }
	}

    if (LnLast+1 < GetBufLineCount(hbuf)) {
    	SetBufIns(hbuf, LnLast+1, 0)
    }
}


//Key Assignments: Ctrl + Tab
macro Hwave_TemplteSnippets()
{
	hwnd = GetCurrentWnd()
	sel = GetWndSel(hwnd)
	LnFirst = sel.lnFirst
	ColFirst = sel.ichFirst
	hbuf = GetCurrentBuf()

	if (GetBufLine(hbuf, 0) == "//magic-number:tph85666031") {
        stop
    }

	if ((sel.ichFirst != sel.ichLim) || (sel.lnFirst != sel.lnLast)) {
		stop
	}

	Ln = LnFirst
	buf = GetBufLine(hbuf, Ln)
	len = StrLen(buf)
	idx = ColFirst
	if (idx < 2) {
		stop
	}
	record = Hwave_getBlankRecord(buf)
	prefix = record.prefix
	keyWordLen = idx - record.idx

	if (keyWordLen == 6) {
		ch = StrMid(buf, idx-6, idx)	
		if (ch == "struct") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " {"))
			InsBufLine(hbuf, Ln+1, Cat(Cat(prefix, "};"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx)
			stop
		}
	}
	else if (keyWordLen == 5) {
		ch = StrMid(buf, idx-5, idx)	
		if (ch == "while") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " ()"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx+2)
			stop
		}
	}
	else if (keyWordLen == 4) {
		ch = StrMid(buf, idx-4, idx)	
		if (ch == "else") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " ()"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx+2)
			stop
		}  else if (ch == "ifel") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-4), "if ()"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(prefix, "}"))
			InsBufLine(hbuf, Ln+3, Cat(prefix, "else ()"))
			InsBufLine(hbuf, Ln+4, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+5, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx)
			stop
		} else if (ch == "elif") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-4), "else if ()"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx+5)
			stop
		}
	}
	else if (keyWordLen == 3) {
		ch = StrMid(buf, idx-3, idx)	
		if (ch == "for") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " (;;)"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx+2)
			stop
		} else if (ch == "#i<") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-3), "#include <>"))
			SetBufIns(hbuf, Ln, 10)
			stop
		} else if (ch == "#i\"") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-3), "#include \"\""))
			SetBufIns(hbuf, Ln, 10)
			stop
		} else if (ch == "#if") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-3), "#if "))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "#endif"))
			SetBufIns(hbuf, Ln, 4)
			stop
		}
	}
	else if (keyWordLen == 2) {
		ch = StrMid(buf, idx-2, idx)
		if (ch == "if") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " ()"))
			InsBufLine(hbuf, Ln+1, Cat(prefix, "{"))
			InsBufLine(hbuf, Ln+2, Cat(Cat(prefix, "}"), StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln, idx+2)
			stop
		} else if (ch == "do") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst), " {"))
			endStr = Cat(prefix, "} while ();")
			InsBufLine(hbuf, Ln+1, Cat(endStr, StrMid(buf, ColFirst, len)))	
			SetBufIns(hbuf, Ln+1, StrLen(endStr))
			stop
		} else if (ch == "#i") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-2), "#include <>"))
			SetBufIns(hbuf, Ln, 10)
			stop
		} else if (ch == "#d") {
			PutBufLine(hbuf, Ln, Cat(StrMid(buf, 0, ColFirst-2), "#define "))
			SetBufIns(hbuf, Ln, 8)
			stop
		}
	}	
}
