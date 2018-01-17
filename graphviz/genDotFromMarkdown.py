#coding=utf-8

import os,sys
import codecs

input_file_name = 'test.md'
dot_file_name = 'test.dot'
output_file_name = 'test.jpg'
# dot_cmd = "d:\Program Files (x86)\Graphviz2.38\bin\dot.exe -Tjpg %s -o %s" % (dot_file_name, output_file_name) 
dot_cmd = "dot.exe -Tjpg %s -o %s" % (dot_file_name, output_file_name) 
g_tab_stack = []
g_func_list = []
g_cur_func_stack = []


dot_template = '''
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


def generateNode(funcBody: FuncBody):
    strArry = []
    strArry.append('\tsubgraph cluster_%s {' % funcBody.name)
    strArry.append('\t\tlabel=%s' % funcBody.name)
    for func in funcBody.func_list:
        strArry.append('\t\t'+func.name+';')
    strArry.append('\t}\n')
    return '\n'.join(strArry)


def generateEdge(funcBody: FuncBody):
    str = '\t%s -> %s [label=\"%s\"]\n' % (funcBody.name, funcBody.func_list[0].name, funcBody.annotate)
    return str


def printFunc(funcBody: FuncBody):
    print(funcBody.name, funcBody.annotate, len(funcBody.func_list))
    for func in funcBody.func_list:
        printFunc(func)

def printFuncList():
    printFunc(g_func_list[0])


def main():
    g_tab_stack.append(0)
    with open(input_file_name) as f:
        lines = f.readlines()
        lineNum = 0
        while lineNum < len(lines):
            line = lines[lineNum]
            # lineNum += 1

            if line[0] == '#':
                item = line[1:].split(':')
                if len(item) == 1:
                    item = line[1:].split('：')
                name = item[0].strip(' \n\t')
                if len(item) > 1:
                    annotate = item[1].strip(' \n\t')
                else:
                    annotate = ''
                func_body = FuncBody(name=name, annotate=annotate)
                g_func_list.append(func_body)
                g_cur_func_stack.append(func_body)
            else:
                tabNum = getTabNum(line)
                if line[tabNum] == '-':
                    if g_tab_stack[-1] < tabNum:
                        g_tab_stack.append(tabNum)
                        g_cur_func_stack.append(g_cur_func_stack[-1].func_list[-1])
                        while lineNum < len(lines):
                            item = line[tabNum+1:].split(':')
                            if len(item) == 1:
                                item = line[tabNum+1:].split('：')
                            name = item[0].strip(' \n\t')
                            if len(item) > 1:
                                annotate = item[1].strip(' \n\t')
                            else:
                                annotate = ''
                            func_body = FuncBody(name=name, annotate=annotate)
                            g_cur_func_stack[-1].func_list.append(func_body)
                            
                            lineNum += 1
                            if lineNum >= len(lines):
                                break
                            line = lines[lineNum]
                            tabNum = getTabNum(line)
                            if g_tab_stack[-1] > tabNum:
                                lineNum -= 1
                                break
                        g_tab_stack.pop()
                        g_cur_func_stack.pop()
                    else:
                        item = line[tabNum+1:].split(':')
                        if len(item) == 1:
                            item = line[1:].split('：')
                        name = item[0].strip(' \n\t')
                        if len(item) > 1:
                            annotate = item[1].strip(' \n\t')
                        else:
                            annotate = ''
                        func_body = FuncBody(name=name, annotate=annotate)
                        g_cur_func_stack[-1].func_list.append(func_body)
            lineNum += 1

    # printFuncList()
        
    dot_node_str = ''
    func_list = [g_func_list[0]]
    while len(func_list) > 0:
        funcBody = func_list[0]
        func_list = func_list[1:]
        dot_node_str += generateNode(funcBody)
        for func in funcBody.func_list:
            if len(func.func_list) > 0:
                func_list.append(func)
    print(dot_node_str)

    dot_edge_str = ''
    func_list = [g_func_list[0]]
    while len(func_list) > 0:
        funcBody = func_list[0]
        func_list = func_list[1:]
        dot_edge_str += generateEdge(funcBody)
        for func in funcBody.func_list:
            if len(func.func_list) > 0:
                func_list.append(func)
    print(dot_edge_str)

    with codecs.open(dot_file_name, 'w+', 'utf-8') as f:
        f.writelines(dot_template % (g_func_list[0].name, dot_node_str, dot_edge_str))
    os.system(dot_cmd)
                    


if __name__ == '__main__':
    if len(sys.argv) < 2:
        os.exit(0)
    input_file_name = sys.argv[1]
    dot_file_name = input_file_name.split('.')[0]+'.dot'
    output_file_name = input_file_name.split('.')[0]+'.jpg'
    main()
