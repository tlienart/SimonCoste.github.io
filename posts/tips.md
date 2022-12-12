+++
titlepost = "Tips and tricks in Julia"
date = "2022"
abstract = "A personnal collection of Julia's nice tricks. "
+++

This post is some kind of a personnal collection of things learnt on-the-fly, small tips and tricks in the Julia language. They're not life-safers and won't make your code work better nor faster, but they'll probably help you write cleaner code, they're incredibly smooth, and using them fills me with an intense satisfaction. I hope this helps. 

**Contents**

\toc

## REPL tricks


Typing `]` in a REPL brings you to package mode -- you can `activate` environments or `add` packages. 

Typing `?` in a REPL brings you to help mode -- type anything and you'll get documentation. 

Typing `;` in a REPL brings you to shell mode -- you can do your regular `ls` and `cd` and `grep` commands. 

To come back to the normal mode, juste type `del`. 


### Writing the output to the REPL

If you're in a REPL and you want to define something, say an array, the ouput will be written in the REPL. In other words, you'll see
```
julia> x = rand(2)
2-element Vector{Float64}:
 0.35720058578070635
 0.5348958549457257
```
If you don't want the output to be displayed, you only have to add `;` at the end of the line. Also, you can chain many expressions in the same line if you separate them with `;`. 
```
julia> x = rand(2);y = 2*x;
```


## Updating Julia

Julia evolves fast. Right now we're at 1.8x, but 1.9 is in alpha and scheduled soon. To upgrade my local julia version, I always use [Abel Siqueira's Jill installer](https://github.com/abelsiqueira/jill). Basically, you just have to 
```
sudo bash -ci "$(curl -fsSL https://raw.githubusercontent.com/abelsiqueira/jill/main/jill.sh)"
```
in your terminal and that's all. 

## Showing off with Unicode

Yes, you can write unicode in Julia. 

No, you should not abuse unicode in Julia. 

Some people just do not know how to reproduce unicode input and they're stuck trying to copy-paste your fancy `⨦(🌁, 🌄) = 🌁 + √🌄` (yes, this is defining $f(a,b) = a+\sqrt{b}$). But Julia is probably the only language where I can write crystal-clear mathematical functions that are directly readable as if they were LaTeX: 
```
 φ(θ) = 0.5 * (√θ - cos(θ))
 ```
 And you can overload and use all the usual symbols, from greek letters (` α, β, Θ...`) to operators (`∫, ∑, ∈, ≤...`), mathbb/mathfrak/mathcal/mathscr letters (`𝕄, ℱ, 𝓝, 𝔖`), and so on. To get all those, see [the julia unicode manual](https://docs.julialang.org/en/v1/manual/unicode-input/). In the VScode extension for julia, when you want to use unicode letters (for instance `\lambda` for `λ`), you type `\lambda` then `shift` and use autocompletion. 

## Various kinds of syntactic sugar

Julia has nice syntactic shortcuts; they're clear, usefull, and simple to use, but some of them are not so well-known. Here's my personnal list. 

### condition ? yes : no

This is the same as in Python. Instead of writing
```
if condition
    x = 0
else
    x = 1
end
```
One can simply use `x = condition ? 0 : 1`. The condition must be a boolean variable. Note that having spaces around the `?` and `:` operators is mandatory.  

### Short-circuit boolean operators

Those are also present in other programming languages but for some reason I always forget which one is which one. The logical *and* and *or* are `&` and `|`. But beware! In `expr1 | expr2`, both expressions are tested. This is slightly inefficient: if `expr1` is true, there's no need to check `expr2`. To avoid these spurious evaluations, we have the « short-circuit » operators `&&` and `||` which do exactly what you think they do. 

You can use these to replace some `if` statements. For instance, `condition && f()` checks if `condition` if true, and if true, performs `f()`. 

### Defining functions

There are at least three ways to define functions in Julia. The classical one reads
```
function f(x)
    return x^2
end
```
and note that one is not forced to use the `return` keyword: if the last line of the code block defining a function is simply an expression, then the function will return this expression. Thus, the former function is strictly the same as
```
function f(x)
    x^2
end
```

Now, there's the inline way: 
```
f(x) = x^2
```
and finally there's the anonymous way:
```
x -> x^2
```
This last way is useful for passing functions as argument of other functions, without hassling to give them a name. Typically, if you want to apply a function to every element in an array, you can use 
```
map(x->x^2, array)
```


### Feeding things to structs

Despite being essentially functional, Julia allows some object-oriented-style code. A very useful tip is that if you defined a custom `Struct`, you might want to call it like a function --- just as in Python, you can override the `self.__call__()` method for your objects. Say you have a struct, 
```
struct Thing
    a
end
```
Typically, this can be a machine-learning model, such as a multi-layer perceptron. The functional way to do this would be to define a `feed` function, such as
```
feed(T::Thing, x) = #code which outputs something
```
but it should be more intuitive if we could call `T(x)` directly instead. This can easily be done with 
```
(T::Thing)(x) = #same code
```

### Piping

You have two functions, say `f(x) = x^2` and `g(x) = sin(x)`. If you want to compute $g(f(x))$ for some random $x$, you can write `g(f(x))`, but you can also pipe the functions: 
```julia
julia> rand() |> f |> g
4.847492976007113e-7
```
and you can also broadcast the functions: 
```julia
julia> rand(3) .|> f .|> g
3-element Vector{Float64}:
 0.4548384389788184
 0.7478851483599316
 0.20344218484963622
```

This works with any function; it is common practice, when using a GPU with CUDA.jl, to put an array or a model to the gpu using `model = model |> gpu` instead of `model = gpu(model)` 

Finally, note that you can broadcast the pipe itself with the same syntax:

```julia
julia> rand(2) .|> (f,g)
2-element Vector{Float64}:
 0.5208181108065045
 0.047596231335982044
```


### Slurping and splatting

Slurping and splatting refer to the two (different) uses of the `...` operator: [see the Julia manual](https://docs.julialang.org/en/v1/manual/faq/#What-does-the-...-operator-do?). 

**Splatting**. If `X = [1, 2, 3]` and `f(a,b,c) = a + b - c` for instance, then `f(X)` obviously gives you an error since there is no method matching `f(::Vector)` or `f(::Array)`. But then, `f(X...)` does the trick. What the slurping operator `...` does is similar to what Python's `*` operator does: it simply unfolds the elements in the array and passes them as argument to the function. This is super useful.

**Slurping**. By contrast you can also use `...` in functions definitions when you don't exactly know how many arguments there might be. Typically, a function defined by `f(args...) = #code ` can take any number of arguments, but they'll be combined into a single argument (a tuple, actually). Look at this: 
```julia
julia> f(x...) = x
f (generic function with 1 method)
julia> f(1,2,3)
(1, 2, 3)
julia> f("a")
("a",)
```


### Ellipsis notation

Python has its famous ellipsis notation for slicing, `...`; roughly speaking, it allows to access a range of indices in a list or array, without having to specify the indices. For instance, if you have an array `x` with 3 dimensions, of size, say, (5,6,7), writing `x[0,:,:]` is the same thing as writing `x[0,...]`. Since `...` is already taken in Julia for the slurping operator, we use `..` instead for the ellipsis notation. This is a part of Chris Rackauckas's package [EllipsisNotation.jl](https://github.com/ChrisRackauckas/EllipsisNotation.jl) which just needs to be installed with Pkg and imported with `using EllipsisNotation`. 


### Identity matrices

The identity matrix is `I`, period. Nothing more is needed (except `using LinearAlgebra` of course). You don't need to specify its size or its datatype, those will be inferred by Julia when you need it. For instance you can very well write `rand(3,3) + I`. 


### Broadcasting and the `@.` macro

The "dot syntax" is well known in Julia: append any operation with a `.` to broadcast it, ie to cast it elementwise. For instance, if you have an array `X`, say `X = rand(10)`, then `sin.(X)` is equivalent to `[sin(x) for x in X]`, or even to `map(sin, X)`. Note that this dot-syntax is almost customary, since `sin(X)` will result in a `MethodError` (there is no method `sin(::Vector{...}))`). Virtually all operations can be dot-broadcasted: `+, -, ^, *, sin, cos, tan`, whatever. But sometimes you need to chain many broadcasting operations and this results in clumpy dotted code: 
```julia
X = rand(10)
Y = sin.(X.^2) .- cos.(X .* sin.(X .+ 1)).^3
```
Fortunately, you can distribute the dot itself using the `@.` macro: 
```
Y = @. sin(X^2) - cos(X * sin(X+1))^3
```

Of course, sometimes you want to dot-broadcast some operations and not others in the same expression, and in this case you need to escape some caracters with `$` as explained in [this post by B. Kaminski](https://www.juliabloggers.com/broadcasting-in-julia-the-good-the-bad-and-the-ugly/?utm_source=ReviveOldPost&utm_medium=social&utm_campaign=ReviveOldPost), but it results in even uglier code. 


## Multiple dispatch

Multiple dispatch is when a function has several definitions according to the type of its arguments. Typically, 
```
function f(x::Int)
    x+1
end

function f(x::String)
    string(x, "+1")
end
```

Here, the function $f$ is said to have two *methods* and you can see all the methods of $f$ and where they are defined with `methods(f)`. You can also add some kind of constraints on the parameters: for instance, if you want a function to take as input two elements of the same type `T`, whatever it is, then

```
function f(a::T, b::T) where {T}
    return "whatever"
end
```


## Inlining

*Inlining* refers to the practice of [replacing a function call by its body](https://en.wikipedia.org/wiki/Inline_expansion#:~:text=In%20computing%2C%20inline%20expansion%2C%20or,body%20of%20the%20called%20function.&text=Inlining%20is%20an%20important%20optimization%2C%20but%20has%20complicated%20effects%20on%20performance.). Instead of calling the function (which wastes a small amount of overhead), the compiler directly uses the code used to define the function. Under certain circumstances, this increases the speed of your program because 1) you lose the overhead time of the function call and 2) the compiler can further optimize inlined expressions which could not have been optimized otherwise. 

Inlining optimization is in general a subtle technique; sometimes it can even fail, for example when you inline huge portions of code. The best practice is to time and benchmark your code to see what works better, see [this post](https://aviatesk.github.io/posts/inlining-101/) by Shuhei Kadowaki. 

In Julia, if you want to tell the compiler to inline a function, you can do this using the `@inline` macro. Apparently, Julia automatically inlines small functions, so you should use this macro for slightly bigger functions, so if you want to forbid Julia to inline them you can use `@noinline`. 





## Logging macros

Most people debug their code by gently sprinkling `println` statements all around their code. In Julia, some very useful macros allow you to do this in a more classy style: they are `@info, @warn, @error, @show, @debug`. You use them by providing variables or `key = values` pairs. For example, 

```julia
julia> x = rand()
0.5541313526244116

julia> @info "This is an info message" x y = x^2
┌ Info: This is an info message
│   x = 0.5541313526244116
└   y = 0.30706155596136
```

The macros `@warn, @error, ...` are similar. At first sight, one might think that these macros are just more specific versions of print statements, but in reality they are internally endowed with metadata which interact with the `Logging` package. 

When you call one of these macros, a *log event* happens. The metadata associated to a log event are: the source module from which the event comes from, the file, the line, an ID and some extra info. Julia's default logger then chooses to display these metadata based on various things. For example, an @info event will display the dictionnary you gave as argument, but not the file or the module, while an @error message will also display the line:

```julia
julia> @info "This is an info message"
[ Info: This is an info message

julia> @error "Something just broke"
┌ Error: Something just broke
└ @ Main REPL[4]:1
```

This example was written in a REPL, hence the line number 1. 

This is good and usually sufficient for one's need, but we only tickled the full power of the `Logging` functionalities in Julia. More can be found on the [JuliaLogging](https://julialogging.github.io/) excellent webpage. 


## Saving stuff to files

You did some experiments, got a nice result under the shape of - say - an array, and you want to keep it somewhere for later. You can of course use the good old `write` function, but at the moment it's way better to use the `BSON.jl` package. This package encodes nearly everything using the Binary JSON format and is really easy to use thanks to the utility functions `@load, @save`. 

Suppose that you have an array of floats to save, and a string: 
```
arr = rand(10)
phrase = "Vote for Pedro"
```
Then you can both save them in the file "output.bson" with 
```
using BSON:@save, @load
@save "output.bson" arr, phrase
```
The file is created or rewritten. Later, when you want to load those variables, you only have to do 
```
using BSON:@load
@load "output.bson" arr, phrase
```
and a variable `phrase` is created with the value you stored last time. Indeed, you don't need to load all the variables you saved. If you only need to work on the string `phrase` you can just do
```
@load "output.bson" phrase
```

## Keyword arguments

It can be a good programming practice to wrap your function arguments inside an `Args` structure. For instance, instead of having

```
function f(size, depth, epsilon, tolerance, number_iterations)
# do stuff using these args
```
one could simply define a type for the arguments and the using it in the signature of the function: 
```julia
mutable Struct Args
    size
    depth
    epsilon
    # etc
end 

function f(args::Args)
# do stuff with args.size, args.depth, etc
```

A very nice way of doing this is to use the `Base.@kwdef` macro, which requires you to use the keywords when instanciating the structure. Taken from the doc itself: 

```julia
julia> Base.@kwdef struct Foo
             a::Int = 1         # specified default
             b::String          # required keyword
         end


julia> Foo(b="hi")
Foo(1, "hi")
```

 
## Type stability

*A function should always return values of the same type.*

This great example is taken from the official doc. Suppose you have a function like `pos(x) = x < 0 ? 0 : x`. You did not specify any types, so Julia needs to infer the types by itself. But here, if `x` is positive, the output is `x` (say, a `Float32`) and if `x` is a negative float, the output is `0`, that is...
```julia
julia> x = -3.0
julia> typeof(pos(x))
Int64
```
The output is an Int. The function `pos` is not type stable -- shame! The solution, here, is `pos(x) = x < 0 ? zero(0) : x`. In general, if you have an object `y` and you want to convert it to the type of `x`, this operation can be performed (if able) by `oftype(x,y)`. There are helper functions, like `one(x)` which returns a unit of the same type of `x`. 
