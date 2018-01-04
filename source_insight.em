macro MultiLineComment()
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
   		idx = 0
   		while (idx < len) {
   			ch = StrMid(buf, idx, idx+1)
   			if ((ch != "\t") && (ch != " ")) {
   				break
   			}
		    idx = idx + 1
   		}
   		if (idx+2 <= len) {
	    	if (StrMid(buf, idx, idx+1) == "/") {
			    idx = idx + 1
	    		if (StrMid(buf, idx, idx+1) == "/") {
	    			doComment = False
	    		}
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
	    	idx = 0
	    	prefix = ""
	    	while (idx < len) {
	    		ch = StrMid(buf, idx, idx+1)
	    		if ((ch != "\t") && (ch != " ")) {
	    			if (idx < commentBeginIdx) {
		    			commentBeginIdx = idx
		    			commentBeginPrefix = prefix
		    		}
	    			break
	    		}
			    prefix = Cat(prefix, ch)
			    idx = idx + 1
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
			idx = 0
			prefix = ""
	    	while (idx < len) {
	    		ch = StrMid(buf, idx, idx+1)
	    		if ((ch != "\t") && (ch != " ")) {
	    			break
	    		}
			    prefix = Cat(prefix, ch)
			    idx = idx + 1
	    	}	    	
	    	if (idx+2 <= len) {
		    	if (StrMid(buf, idx, idx+1) == "/") {
			    	idx = idx + 1
			    	if (StrMid(buf, idx, idx+1) == "/") {
			    		idx = idx + 1
			    		PutBufLine(hbuf, Ln, Cat(prefix, StrMid(buf, idx, len)))
			    	}
		    	}
	    	}
	    	Ln = Ln + 1
	    }
	}	
   	if (LnLast+1 < GetBufLineCount(hbuf)) {
   		SetBufIns(hbuf, LnLast+1, 0)
   	}
}
