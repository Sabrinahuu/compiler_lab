; SysY Runtime Library
declare i32 @getint()
declare void @putint(i32)
declare void @putch(i32)

; Global constants and variables
@N = constant i32 6
@LIMIT = constant i32 100
@bias = global i32 3


define i32 @transform(i32 %x) {
entry:
    %x.addr = alloca i32
    %y = alloca i32

    store i32 %x, i32* %x.addr

    %x.val = load i32, i32* %x.addr
    %rem = srem i32 %x.val, 2
    %cond = icmp eq i32 %rem, 0

    br i1 %cond, label %if.then, label %if.else

if.then:
    %x.then = load i32, i32* %x.addr
    %mul = mul i32 %x.then, 2
    %bias.then = load i32, i32* @bias
    %add = add i32 %mul, %bias.then
    store i32 %add, i32* %y

    br label %if.end

if.else:
    %x.else = load i32, i32* %x.addr
    %div = sdiv i32 %x.else, 2
    %bias.else = load i32, i32* @bias
    %sub = sub i32 %div, %bias.else
    store i32 %sub, i32* %y

    br label %if.end

if.end:
    %result = load i32, i32* %y
    ret i32 %result
}

define i32 @process(i32* %a, i32 %n) {
entry:
    %a.addr = alloca i32*
    %n.addr = alloca i32
    %i = alloca i32
    %sum = alloca i32
    %x = alloca i32
    %value = alloca i32

    store i32* %a, i32** %a.addr
    store i32 %n, i32* %n.addr
    store i32 0, i32* %i
    store i32 0, i32* %sum

    br label %while.cond


while.cond:
    %i.cond = load i32, i32* %i
    %n.val = load i32, i32* %n.addr
    %while.cmp = icmp slt i32 %i.cond, %n.val

    br i1 %while.cmp, label %while.body, label %while.end


while.body:
    ; x = a[i]
    %array.ptr = load i32*, i32** %a.addr
    %i.index = load i32, i32* %i
    %elem.ptr = getelementptr i32, i32* %array.ptr, i32 %i.index
    %elem = load i32, i32* %elem.ptr
    store i32 %elem, i32* %x

    ; i = i + 1
    %i.old = load i32, i32* %i
    %i.next = add i32 %i.old, 1
    store i32 %i.next, i32* %i

    ; if (!(x >= 0))
    %x.neg.val = load i32, i32* %x
    %x.ge.zero = icmp sge i32 %x.neg.val, 0
    %x.is.negative = xor i1 %x.ge.zero, true

    br i1 %x.is.negative, label %while.continue, label %check.limit


check.limit:
    ; if (x > LIMIT)
    %x.limit.val = load i32, i32* %x
    %limit.val = load i32, i32* @LIMIT
    %over.limit = icmp sgt i32 %x.limit.val, %limit.val

    br i1 %over.limit, label %while.end, label %check.range


check.range:
    ; x >= 10
    %x.range1 = load i32, i32* %x
    %ge10 = icmp sge i32 %x.range1, 10

    br i1 %ge10, label %check.le50, label %check.zero


check.le50:
    ; x <= 50
    %x.range2 = load i32, i32* %x
    %le50 = icmp sle i32 %x.range2, 50

    br i1 %le50, label %use.transform, label %check.zero


check.zero:
    ; || x == 0
    %x.zero.val = load i32, i32* %x
    %is.zero = icmp eq i32 %x.zero.val, 0

    br i1 %is.zero, label %use.transform, label %normal.case


use.transform:
    %x.transform = load i32, i32* %x
    %transformed = call i32 @transform(i32 %x.transform)
    store i32 %transformed, i32* %value

    br label %add.sum


normal.case:
    ; if (x != LIMIT)
    %x.normal = load i32, i32* %x
    %limit.normal = load i32, i32* @LIMIT
    %not.limit = icmp ne i32 %x.normal, %limit.normal

    br i1 %not.limit, label %subtract.one, label %keep.value


subtract.one:
    %x.sub = load i32, i32* %x
    %sub.one = sub i32 %x.sub, 1
    store i32 %sub.one, i32* %value

    br label %add.sum


keep.value:
    %x.keep = load i32, i32* %x
    store i32 %x.keep, i32* %value

    br label %add.sum


add.sum:
    ; sum = sum + value
    %sum.old = load i32, i32* %sum
    %value.val = load i32, i32* %value
    %sum.new = add i32 %sum.old, %value.val
    store i32 %sum.new, i32* %sum

    br label %while.continue


while.continue:
    br label %while.cond


while.end:
    %sum.result = load i32, i32* %sum
    ret i32 %sum.result
}


define i32 @main() {
entry:
    %data = alloca [6 x i32]
    %i = alloca i32
    %result = alloca i32

    store i32 0, i32* %i

    br label %input.cond


input.cond:
    ; while (i < N)
    %i.cond = load i32, i32* %i
    %n.val = load i32, i32* @N
    %input.cmp = icmp slt i32 %i.cond, %n.val

    br i1 %input.cmp, label %input.body, label %input.end


input.body:
    ; data[i] = getint()
    %input.val = call i32 @getint()

    %i.index = load i32, i32* %i

    %elem.ptr = getelementptr [6 x i32],
                              [6 x i32]* %data,
                              i32 0,
                              i32 %i.index

    store i32 %input.val, i32* %elem.ptr

    ; i = i + 1
    %i.old = load i32, i32* %i
    %i.next = add i32 %i.old, 1
    store i32 %i.next, i32* %i

    br label %input.cond


input.end:
    ; result = process(data, N)
    %data.ptr = getelementptr [6 x i32],
                              [6 x i32]* %data,
                              i32 0,
                              i32 0

    %n.call = load i32, i32* @N

    %process.result = call i32 @process(
        i32* %data.ptr,
        i32 %n.call
    )

    store i32 %process.result, i32* %result

    ; putint(result)
    %output = load i32, i32* %result
    call void @putint(i32 %output)

    ; output newline
    call void @putch(i32 10)

    ret i32 0
}