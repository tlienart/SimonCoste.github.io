+++
titlepost = "Random analytic functions: Ryll-Nardzewski's theorem"
date = "April 2021"
abstract = "What happens at the boundary of the disk of convergence of random analytic series. "
+++

In 1896, Émile Borel asked what can happen at the border of the disk of convergence of a Taylor series:
> *Étant donné une série de Taylor, il est intéressant de savoir si elle peut être prolongée en quelque manière au-delà de son cercle de convergence ou si ce cercle est une coupure.*

This is a vast and difficult question, but surprisingly enough, it has an answer for *random* Taylor series, which are series whose coefficients are random. 

At first sight, it might seem difficult to study the behaviour of a function which is itself random, and one might be tempted to say that *random objects have random behaviours*; but as Borel hinted in his 1896 paper, randomness comes with averaging, and averaging rules out eccentricity. That's the surprising result I would like to show in this note: this result essentially says that **_most_** **random functions cannot be extended outside of their disk of convergence**.

The precise statement is below; it is due to the Polish mathematician Czesław Ryll-Nardzewski in 1953. 

## Hadamard's formula

Let us remind a basic fact on the radius of convergence: if $f(z)=\sum a_n z^n$ is a power series, its radius of convergence is given by [Hadamard's formula](https://en.wikipedia.org/wiki/Cauchy%E2%80%93Hadamard_theorem), 
@@important
$$ r = \frac{1}{\limsup |a_n|^\frac{1}{n}}. $$
@@

Inside the disk $D(0,r)$, the power series converges, but this says nothing on what happens on the border of the disk or outside. Does $f(z)$ approach a limit as $z$ approaches the border, for instance if $z\to 1$? Does it erratically diverge? Are there some points on the boudary, such that $f$ can be extended analytically around this point? 

Think about the series $\sum z^n$. Its radius of convergence is 1, but since the sum is equal to $(1-z)^{-1}$, we can extend it at any point of the circle of radius 1, except at the point $z=1$; in fact, we can extend this function at every point of $\mathbb{C}\setminus 1$, even if the series representation only holds in the disk $D(0,1)$. 

## What happens at the border

We say that a complex number $w$ on the circle $C_1 = \{|z|=1\}$ is **regular** if there is a $\delta > 0$ such that $f$ can be extended analytically on $D(w, \delta)$. By the properties of analytic functions, this extension is unique. If a point is not regular, it is called **singular**. 

The set $\mathscr{R}$ of regular points of $f$ is an open subset of $C_1$, and among functions with a radius of convergence equal to 1, it can have very different behaviours:
- If $f(z) = \sum_{n=0}^\infty (1-z)^{-1}$, then the only non-regular point is $1$, thus $\mathscr{R} = C_1 \setminus 1$. Building on this example can construct functions with any finite number of singular points. 
- At the other side of the spectrum is $f(z) = \sum_{n=1}^\infty z^{n!}$. It can be shown using [Hadamard's lacunary series theorem](https://en.wikipedia.org/wiki/Ostrowski%E2%80%93Hadamard_gap_theorem) or any [gap theorem](https://en.wikipedia.org/wiki/Fabry_gap_theorem) that $\mathscr{R}$ is empty, that is, there is no hope of extending $f$ on any open set containing some point in $C_1$. 

This last case where $\mathscr{R}$ is empty might seem pathological; it is actually not. If $\mathscr{R}$ is empty, we say that $C_1$ is a **coupure** for $f$, following Borel's vocabulary.

## Random analytic functions

In many of his works, Borel was interested in the behaviour of '_séries quelconques_', as term he sometimes used to mean 'random'. A modern setting would be to take a sequence of (complex or real) random variables $X_0, X_1, X_2, ...$, and define 
$$ f(z) = \sum_{n=0}^\infty X_n z^n. $$

This is a random analytic function, and its radius of convergence $r = 1/\limsup |X_n|^{1/n}$  is a random variable; however, classical theorems in probability such as [Kolmogorov's zero-one law](https://en.wikipedia.org/wiki/Kolmogorov%27s_zero%E2%80%93one_law) say that when the $X_n$ are independent[^1], then $r$ is almost surely a constant -- possibly $\infty$. 

Sometimes, this can be checked manually; this is the case for two common examples of random functions with a finite radius of convergence, the Rademacher and the Gaussian series.

- **Rademacher**: $X_n$ is equal to $-1$ or $+1$ with probability $1/2$. In this case $|X_n|^{1/n}=1$ for every $n$, hence $r=1$.
- **Gaussian**:  $X_n$ is a standard gaussian. In this case one can prove that $r=1$ too. 

Look at the behaviour of (two realizations of) these functions, inside their radius of convergence.  

![](/posts/img/gaussian2k.png)

![](/posts/img/rademacher2k.png)


~~~
<div class="row">
  <div class="container">
    <img class="left img-small" src="/posts/img/inset.png">
    <p>
    The Gaussian function is on top, the Rademacher function at the bottom. The small inset on the left is the color scheme for these <a href="https://complex-analysis.com/content/domain_coloring.html">domain colourings</a>.  
    </p>
    <div style="clear: both"></div>      
  </div>
</div>
~~~

We can see a more and more erratic behaviour closer to the border of $C_1$, with denser zeros and windings. It is tempting to say that both functions have a coupure at $C_1$. That's actually the case and it's the content of the second part of this note. 

## Two theorems on random analytic functions

When $f$ is a random analytic function with a radius of convergence almost surely equal to 1, one can define $\mathscr{R}$ as the set of all points which are almost surely regular for $f$, and this set is an open set[^2]. If it is empty, then $f$ has a coupure at $C_1$. 

@@important 

**Theorem** 

If the $X_n$ are symmetric random variables and if $f(z)=\sum X_n z^n$ has a radius of convergence of $1$, then either every point in $C_1$ is regular, or $C_1$ is a coupure for $f$.  

@@

By *symmetric*, we mean that the law of $X_n$ and the law of $-X_n$ are equal.

*Proof.* Let us suppose that $\mathscr{R}$ is not empty. It contains a small arc interval of the circle, say $\{e^{it} : t \in ]a,b]\}$, and there is an integer $m$ such that the arc length of this interval is bigger than $1/m$.
Now, if the $X_n$ are symmetric, then for any deterministic choice of signs $s_n = \pm 1$, the law of the random analytic functions
$$ \sum s_n X_n z^n $$
are the same as the law of $f$; in particular, if we set $s_n$ to be $-1$ if $n \equiv k$ modulo $m$ and $1$ otherwise, we obtain a new random series $f_k$ with the same law as $f$. But
$$ f(z) - f_k(z) = 2\sum_{n=0}^\infty X_{k + mn}z^{k + mn} = 2z^k g(z)$$
for some function $g$, which clearly satisfies $g(z e^{2i\pi/m}) = g(z)$. So, the left hand side of the preceding equation almost surely has $\mathscr{R}$ as a regular set, hence so does the right-hand side. But since $g$ is invariant by rotations of angle $2\pi/m$, it means that the set of regular points of $g$ must also contain $e^{2i\pi/m}\mathscr{R}$, which contains the whole circle $C_1$; in other words, $g$ can be extended outside $C_1$, and so does $2z^k g(z)=f(z)-f_k(z)$. 

We finally note that $f_0+ \dotsb + f_{m-1} = (m-2)f$, so that $(f - f_0) + \dotsb + (f - f_{m-1}) = 2f$. But this would mean that the set $\mathscr{R}$ of regular points of $f$ contains $C$. 

In other words, either $\mathscr{R}$ is empty, or it is equal to $C_1$. 

We now turn to the general case, where the distribution of the $X_n$ is not necessarily symmetric; with a clever argument, we can actually symmetrize them and use the preceding result to get Ryll-Nardzewski's theorem. 



@@important

**Ryll-Nardzewski's theorem**

If the $X_n$ are random complex numbers such that $f(z) = \sum X_n z^n$ almost surely has radius of convergence 1, then only two things can happen.

(1) Either the circle $C_1$ is a coupure of $f$.

(2) Or, there is a *deterministic* analytic function $\tilde{f}$ with radius of convergence equal to 1, and such that:
- the radius of convergence of $f-\tilde{f}$ is $s>1$
- the circle $C_s$ is a coupure for $f-\tilde{f}$. 

@@

This was beforehand a conjecture, and it was proved by the Polish mathematician C. Ryll-Nardzewski; a few simpler proofs appeared afterwise. This one is notably simple and is drawn from J.-P. Kahane's book, *Some random series of functions*. The same statement actually holds on assumptions weaker than independence of the $X_n$'s. 

*Proof*. Let us suppose that we are not in the first case, that is, the set of almost sure regular points $\mathscr{R}$ is not empty. We introduce another sequence of random variables $\tilde{X}_n$, which are independent of the $X_n$'s and have the same law. We note $\tilde{F}(z) = \sum \tilde{X}_n z^n$ their Taylor series: it has the same distribution as $f$. 

Now, the coefficients of the random analytic function $g(z) = f(z) - \tilde{F}(z)$ are $X_n - \tilde{X}_n$, so they are symmetric and the preceding result applies: almost surely, $g$ has a coupure at its radius of convergence $s$. Since both $f,\tilde{F}$ have radius of convergence 1, we must have $s\geqslant 1$: but can we have $s=1$? Well, since $f$ and $\tilde{F}$ both have a nonenmpty set of regular points on the circle of radius 1, it must mean that these points are also regular for $g$: if $g$ has a coupure, it cannot be on the circle of radius 1, and we obtain $s>1$. 

Now comes the end: since $f$ and $\tilde{F}$ are independent, we can essentially consider that $\tilde{F}$ is not random... More precisely, conditionnaly on (almost every) realization $\tilde{f}$ of $\tilde{F}$, the random function $f - \tilde{F} = f - \tilde{f}$ has a coupure at $s>1$. 

This last statement is actually much stronger than the statement of the theorem, since it means that there are *many* deterministic functions such that the conclusion holds: almost every realization of $\tilde{F}$...

### The $L^1$ case 

The last argument of the proof will be less shady if we allow an extra assumption: we can suppose that the $X_n$ are $L^1$. Instead of considering one particular realization of $\tilde{F}$, we can simply average with respect to $\tilde{F}$, which has the same distribution as $f$, so 
$$\mathbf{E}[\tilde{F}(z)] = \sum \mathbf{E}[\tilde{X}_n]z^n  = \sum \mathbf{E}[X_n]z^n.$$
 The second case of the theorem now reads:

@@important
$f(z) - \sum_{n=1}^\infty \mathbf{E}[X_n]z^n$ has a coupure at $C_s$ for some  $s>1$.
@@

## A Poisson example

I recently stumbled across an example illustrating this: consider the case where $X_n$ are independent Poisson random variables with parameter $d^n$ for some common $d$. Routine arguments show that the radius of convergence of $f$ is $1/d$, but in fact there is no coupure at $1/d$. To see why, note that
$$\sum \mathbf{E}[X^n]z^n = \sum d^n z^n = \frac{1}{1-zd} $$
so that
$$f(z) - \frac{1}{1 - zd}= \sum (X_n - d^n)z^n. $$
By elementary concentration arguments, it is possible to prove that $\limsup|X_n - d^n|^{1/n} = \sqrt{d}$, and consequently $f(z) - (1-zd)^{-1}$ has a radius of convergence equal to $1/\sqrt{d}$, and the singularity at $1/d$ was really isolated. It is also possible to show that $f(z) - (1-zd)^{-1}$ has a coupure at $1/\sqrt{d}$, thus giving a full illustration of Ryll-Nardzewski's theorem.

## References 


Jean-Pierre Kahane, *Some random series of functions*

Czesław Ryll-Nardzewski, *D. Blackwell's conjecture on power series with random coefficients* (Studia Math., 1953)

Émile Borel, *Sur les séries de Taylor* (C.R. de l'Acad., 1896)


### Notes


[^1]: Note that we only asked the $X_n$ to be independent, not necessarily identically distributed.

[^2]: The right way to define $\mathscr{R}$ is as the union of all arc intervals $\{e^{2i\pi t} : t\in ]a,b[\}$ with $a,b$ rationals, and such that almost surely every point in this interval is regular for $f$. That way, $\mathscr{R}$ is measurable (as a countable union of intervals) and every point in $\mathscr{R}$ is almost surely regular.
