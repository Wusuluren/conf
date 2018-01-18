#coding=utf-8
import os,sys
import codecs

g_input_file_name = ''
g_dot_file_name = ''
g_output_file_name = ''
g_tab_stack = []
g_func_list = []
g_cur_func_stack = []
g_all_func = {}
g_dot_template = '''
digraph G {
	rankdir=LR
	edge [fontname="Microsoft YaHei"]
	node [shape=record, fontname="Microsoft YaHei"]	
    %s
%s	
%s
}
'''

class FuncBody(object):
    def __init__(self, name='', annotate=''):
        self.name = name
        self.annotate = annotate
        self.func_list = []


def getTabNum(line):
    num = 0
    for c in line:
        if c != '\t':
            break
        num += 1
    return num


def generateDotNode(funcBody: FuncBody):
    strArry = []
    strArry.append('\tsubgraph cluster_%s {' % funcBody.name)
    strArry.append('\t\tlabel=%s' % funcBody.name)
    for func in funcBody.func_list:
        strArry.append('\t\t'+func.name+';')
    strArry.append('\t}\n')
    return '\n'.join(strArry)


def generateDotEdge(funcBody: FuncBody):
    str = '\t%s -> %s [label=\"%s\"]\n' % (funcBody.name, funcBody.func_list[0].name, funcBody.annotate)
    return str


def getFuncBodyFromStr(line):
    item = line.split(':')
    if len(item) == 1:
        item = line.split('：')
    name = item[0].strip(' \n\t')
    if len(item) > 1:
        annotate = item[1].strip(' \n\t')
    else:
        annotate = ''
    if name in g_all_func:
        g_all_func[name] += 1
        name = '%s__%d' % (name, g_all_func[name])
    else:
        g_all_func[name] = 0    
    func_body = FuncBody(name=name, annotate=annotate)
    return func_body


def printFunc(funcBody: FuncBody, tab=0):
    print('\t'*tab, funcBody.name, funcBody.annotate, len(funcBody.func_list))
    for func in funcBody.func_list:
        printFunc(func, tab=tab+1)


def printFuncList():
    printFunc(g_func_list[0], tab=0)


def genDotStrFromFuncList(genDotStrFunc):
    dot_str = ''
    func_list = [g_func_list[0]]
    while len(func_list) > 0:
        func_body = func_list[0]
        func_list = func_list[1:]
        dot_str += genDotStrFunc(func_body)
        for func in func_body.func_list:
            if len(func.func_list) > 0:
                func_list.append(func)
    return dot_str


def genDotFromMarkdown():
    g_tab_stack.append(0)
    with open(g_input_file_name) as f:
        lines = f.readlines()
        lineNum = 0
        while lineNum < len(lines):
            line = lines[lineNum]

            if line[0] == '#':  # entry point
                func_body = getFuncBodyFromStr(line[1:])
                g_func_list.append(func_body)
                g_cur_func_stack.append(func_body)
                lineNum += 1
            else:                
                def procssChild(lineNum):
                    nonlocal lines
                    line = lines[lineNum]                    
                    tabNum = getTabNum(line)
                    # print(line.strip('\n'), tabNum)
                    if line[tabNum] == '-':
                        if g_tab_stack[-1] < tabNum:  # begin of child
                            g_tab_stack.append(tabNum)
                            g_cur_func_stack.append(g_cur_func_stack[-1].func_list[-1])
                            lineNum = procssChild(lineNum)
                        elif g_tab_stack[-1] > tabNum:  # end of child
                            for i in range(g_tab_stack[-1] - tabNum):
                                g_tab_stack.pop()
                                g_cur_func_stack.pop()
                        else:
                            func_body = getFuncBodyFromStr(line[tabNum+1:])
                            g_cur_func_stack[-1].func_list.append(func_body)
                            lineNum += 1
                    return lineNum
                lineNum = procssChild(lineNum)

    # printFuncList()
        
    dot_node_str = genDotStrFromFuncList(generateDotNode)
    # print(dot_node_str)

    dot_edge_str = genDotStrFromFuncList(generateDotEdge)
    # print(dot_edge_str)

    with codecs.open(g_dot_file_name, 'w+', 'utf-8') as f:
        f.writelines(g_dot_template % (g_func_list[0].name, dot_node_str, dot_edge_str))
    dot_cmd = 'dot -Tjpg %s -o %s' % (g_dot_file_name, g_output_file_name)
    # print(dot_cmd)
    os.system(dot_cmd)
                    

def usage():
    print('python genDotFromMarkdown file.md')
    os.exit(0)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        usage()
    g_input_file_name = sys.argv[1]
    g_dot_file_name = g_input_file_name.split('.')[0]+'.dot'
    g_output_file_name = g_input_file_name.split('.')[0]+'.jpg'
    genDotFromMarkdown()
