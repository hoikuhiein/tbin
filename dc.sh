#! /bin/bash

#函数作用
#把一个任意长度的字符串转化为一个大整数，字符串从左到右权值变小

#可以给一个邮件地址作为参数，然后得到一个大整数
#然后可以用dc命令从整数得到电子邮件地址
#dc -e xxxxxP
#xxxxx为运行程序结束时得到的一个长整数
#P为dc中的输出命令

script_name=$(basename $0) #script name

#一个简单的帮助函数
usage ()
{
    echo
    echo "USAGE: $script_name your_email_address"
    echo
    echo
    echo "Example:"
    echo " $script_name example@example.com"
    echo
    echo
    exit 1
}

if [[ -z "$@" ]];then
    usage
else

    email_address="$@"
fi

declare -a num_array
#od命令是为了将字符串转为整数形式
#tr命令是为了去除od命令产生的每16字节的回车。不过试了下，好像可以不用去除
#直接就可以num_array=(`echo $email_address | od -An -t dC `)

num_array=(`echo $email_address | od -An -t dC | tr -d "\n"`)
num_array=(`echo $email_address | od -An -t dC `)

answer=$(echo ${num_array[0]}*${num_array[2]} | bc)

length=${#num_array[@]}

tmp=1
answer=0

for(( i=$length-1;i>=0;i-- ))
do
    tmp=${num_array[$i]}
    for(( j=$length-1-$i;j>0;j-- ))
    do
        tmp=$(echo $tmp*256|bc)
        #这里用到tr命令是因为，当tr的输出长度超过68位时会输出一个断行的标志
        #字符串"\ "，这里把它去除，不然当你的输出字符串超过27时就会出错
        #也可以这样tmp=$(echo $tmp|tr -d ‘\\\ ‘)
        tmp=$(echo $tmp|tr -d "\\\\\ ")
    done
    answer=$(echo $answer+$tmp | bc)
    #这里用到tr命令是因为，当tr的输出长度超过68位时会输出一个断行的标志
    #字符串"\ "，这里把它去除，不然当你的输出字符串超过27时就会出错
    #也可以这样tmp=$(echo $tmp|tr -d ‘\\\ ‘)
    answer=$(echo $answer|tr -d "\\\\\ ")

done

echo $answer
