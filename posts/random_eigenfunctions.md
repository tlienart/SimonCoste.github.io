+++
titlepost = "Waves on donuts"
date = "August 2021"
abstract = "A nice plot of random Laplace eigenfuctions on the torus, also called random arithmetic waves."
reeval=true
+++

![](/posts/img/donuts/1105_color.png)

The Laplace eigenequation on a sphere, a torus, or any Riemannian manifold is 
\begin{equation}\label{0}\Delta f + \lambda f = 0\end{equation}
where $\Delta = \partial^2_x + \partial^2_y$ is the [Laplace operator](https://en.wikipedia.org/wiki/Laplace%E2%80%93Beltrami_operator) on the manifold. 
On the torus $\mathbb{T} = \mathbb{R}^2/\mathbb{Z}^2$, this equation is well understood and the goal of this note is simply to plot the typical solutions -- they look like the donut above. 

The only values $\lambda$ for which there are solutions to \eqref{0} are multiples of $4\pi^2$,  
$$\lambda_n = 4\pi^2 n$$
where $n$ is an integer that can itself be written as the sum of two squares, ie $n = x^2 + y^2$. The function $f(z_1, z_2) = e^{2i\pi (xz_1 + yz_2)}$ is easily seen to be an eigenfunction: indeed,   
\begin{align}(\partial^2_{z_1} + \partial^2_{z_2}) f (z_1, z_2) &= (2\pi i )^2 x_1^2 f(z_1, z_2) + (2\pi i )^2 x_2^2 f(z_1, z_2) \\
&= -4\pi^2 (x_1^2 + x_2^2)f(z_1, z_2)\\
&= - \lambda_n f(z_1, z_2). 
\end{align}

## Sum of squares

Determining  if an integer $n$ satisfies this property, to be the sum of two squares, is an old problem with a long history - it dates back to Diophante. Fermat gave the [first characterization](https://en.wikipedia.org/wiki/Fermat%27s_theorem_on_sums_of_two_squares) of such *prime* numbers. The general theorem is as follows.

@@important
An integer $n \geqslant 1$ can be written as the sum of two squares if and only if, in its prime decomposition, the primes $p$ with of the form $p = 4k + 3$ have an odd power. If it is the case, then the number of ways $r(n)$ to write $n$ as a sum of two squares is given by
$$r(n) = 4(d_1(n) - d_3(n))$$
where $d_k(n)$ is the number of divisors of $n$, not necessarily primes, which are congruent to $k$ modulo $4$. 
@@
For example, $10 = 2 \times 5$; it has exactly four divisors $1,2,5,10$, two of which are congruent to 1 modulo 4, two others to 2.
Consequently, $d_1(10) = 2$ and $d_3(10) = 0$ and $r(10) = 8$. These "sum-of-squares-representations" of 10 are 
\begin{align}
& 1^2 + 3^2 &&&&&&& 3^2 + 1^2\\
& (-1)^2 + 3^2 &&&&&&& (-3)^2 + 1^2\\
& 1^2 + (-3)^2 &&&&&&& 3^2 + (-1)^2\\
& (-1)^2 + (-3)^2 &&&&&&& (-3)^2 + (-1)^2\\
\end{align}

Here is a little function for generating all these representations (it is by no means optimized in any way):
```julia:sos
function SOSrep(n::Int)
    """ Returns the list of Sum-Of-Squares representations.
    Returns an empty list if there are none. """
    square_reps = []
    for i in 1:sqrt(n)-1
        if isinteger(sqrt(n - i^2))
            j = sqrt(n - i^2)
            append!(square_reps,  [[i,j], [i,-j], [j,i], [j,-i]])
        end
    end
    if isinteger(sqrt(n))
        j = sqrt(n)
        append!(square_reps, [[0,j], [0, -j], [j, 0], [-j, 0]])
    end
    return square_reps
end

```

## Random arithmetic waves

Let us go back to the Laplace equation \eqref{0}. Let $n$ be an integer that can be written as a sum of squares and let $\lambda_n$ be the associated eigenvalue. 
Then, the subspace $\mathscr{E}_n$ of solutions of \eqref{0} has dimensions $r(n)$, the number of ways to write $n$ as a sum of squares discussed above. Let $\mathscr{S}$ be the set of couples $x=(x_1,x_2)$ with $n= x_1^2 + x_2^2$; then, a basis of $\mathscr{E}_n$ is given by the elementary functions
\begin{equation}
e_{x} : (z_1, z_2) \in \mathbb{T} \mapsto \exp\{ 2i\pi (x_1 z_1 + x_2 z_2) \}
\end{equation}
and the solutions of \eqref{0} are all the linear combinations of these $r(n)$ functions, namely the functions of the form
$$ \sum_{x \in \mathscr{S}} \alpha_x e_x $$
where $\alpha_x$ are complex numbers. What we call **random arithmetic waves** are random elements of $\mathscr{E}_n$ obtained by choosing the $\alpha_x$ to be iid standard complex Gaussian variables[^1]. The resulting random function $f_n$ is a random Gaussian field; it can be viewed as a typical element of $\mathscr{E}_n$, and there is a vast litterature on its behaviour. Usually, it is more natural to study *real* Gaussian fields, and for this we have to ensure that $f_n$ is real by enforcing some minor constraints on the $\alpha_x$: we simply ask that $\alpha_{-x} = \overline{\alpha_x}$ (complex conjugate). 

We generate a random arithmetic wave with the following function:
```julia:generate
function generate_RAW(n::Int)
    Λ = SOSrep(n)
    if isempty(Λ)
        return nothing
    else
        E = [(x,y) -> exp(2im*pi*(λ[1]*x + λ[2]*y)) for λ in Λ] #exponentials
        X = [randn() + 1im*randn() for λ in Λ]
        f(x,y) = sum(real(X.*[e(x,y) for e in E])) / sqrt(length(Λ))
        return f
    end
end
f = generate_RAW(85) #hide
```
Let us generate some arithmetic wave; most numbers have very few sum-of-squares representations (0,4 or 8), but $85 = 5 \times 17$ has 16 of them. 
```
f = generate_RAW(85)
```
Also, 71825 has 68 square representations, and 801125 has 124, which is a lot. 



## Some code



A torus can be parametrized with two coordinates $(\theta, \varphi) \in [0,2\pi)^2$ by the [following formulas](https://en.wikipedia.org/wiki/Torus#Geometry):
```
X(θ, φ) = (2 + cos(θ)) * cos(φ)
Y(θ, φ) = (2 + cos(θ)) * sin(φ)
Z(θ, φ) = sin(θ)
```

And now, let's use Julia's `GLMakie`, which is [Makie](http://makie.juliaplots.org/stable/)'s backend for GPU 2d and 3d plotting, to see how $f$ looks like. We're going to draw a mesh of $[0, 2\pi)^2$ with a mesh-size of $\varepsilon$.
```julia:mesh
X(θ, φ) = (2 + cos(θ)) * cos(φ)#hide
Y(θ, φ) = (2 + cos(θ)) * sin(φ)#hide
Z(θ, φ) = sin(θ)#hide
ε = 0.01
t = 0:ε:2π+ε ; u = 0:ε:2π+ε
x = [X(θ, φ) for θ in t, φ in u]
y = [Y(θ, φ) for θ in t, φ in u]
z = [Z(θ, φ) for θ in t, φ in u]
```

For each mesh point $(\theta, \varphi)$, we'll color the corresponding point of the torus, $(X(\theta, \varphi), Y(\theta, \varphi), Z(\theta, \varphi))$, with a color representing the field $f_n(\theta, \varphi)$. 

```julia:raw
using GLMakie

field = [f(θ, φ) for θ in t, φ in u]
fig, ax, pltobj = surface(x, y, z, color = field, 
        colormap = :vik,
        lightposition = Vec3f0(0, 0, 0.8), 
        ambient = Vec3f0(0.6, 0.6, 0.6),
        backlight = 5f0, 
        show_axis = false) 

cbar = Colorbar(fig, pltobj,
        height = Relative(0.4), width = 10 )

fig[1,2] = cbar #hide
set_theme!(figure_padding = 0)#hide
save(joinpath(@OUTPUT, "raw.png"), fig) #hide
```
\fig{raw}

Instead of plotting each color, we can only plot the sign of $f_n$, black if positive and white if negative. 
The set of points of the torus where $f_n$ is zero is called the **nodal line** while the sets $\{f_n >0\}$ and $\{f_n < 0 \}$ are called **nodal sets**. 

```julia:raw2
signs = [x > 0 ? 0 : 1 for x in field]
fig2, ax2, pltobj2 = surface(x, y, z, color = signs, 
        colormap = :ice,
        lightposition = Vec3f0(0, 0, 0.8), 
        ambient = Vec3f0(0.6, 0.6, 0.6),
        backlight = 5f0, 
        show_axis = false) 
save(joinpath(@OUTPUT, "raw2.png"), fig2) #hide
```
\fig{raw2}

With a few processing and computational power, one can get much detailed pictures ! 

## Gallery

Here are some pictures of realizations of various arithmetic waves associated with different values of $n$. The left picture is the nodal set ($\{ f > 0 \}$ is dark), while the right one is a heatmap: white is close to zero, red is negative and green is positive. Note that the left and right picture do not correspond to the same realization of the wave (I'll update this soon to see the same realization). 

You can use these pictures if you want, but if so please mention this page.  

@@twopic
![](/posts/img/donuts/41.png)
![](/posts/img/donuts/41_color.png)

$n = 41$, dimension 8

![](/posts/img/donuts/100.png)
![](/posts/img/donuts/100_color.png)

$n=100$, dimension 12

![](/posts/img/donuts/985.png)
![](/posts/img/donuts/985_color.png)

$n=985$, dimension 16

![](/posts/img/donuts/1105.png)
![](/posts/img/donuts/1105_color.png)

$n=1105$, dimension 28

![](/posts/img/donuts/71825.png)
![](/posts/img/donuts/71825_color.png)

$n = 71825$, dimension 64
@@


## Notes and references

The paper [Nodal length fluctuations for RAW](https://arxiv.org/pdf/1111.2800.pdf) by Krishnapur et al. studies the length of the nodal lines of random arithmetic waves, while [this paper](https://arxiv.org/pdf/math-ph/0702081.pdf) by Rudnick and Wigman studies the volume of nodal sets. See the references in these papers for more litterature on the topic. For spherical random waves or plane random waves, Dimitry Belyaev has some [nice pictures](http://people.maths.ox.ac.uk/belyaev/) on his website. 

Also, a [gallery](https://lazarusa.github.io/BeautifulMakie/) of Makie plots which turned out to be quite useful.

Extra pictures on request.



[^1]: Usually there is also a normalization by $(2r(n))^{-1/2}$, but it's not important. 
