+++
titlepost = "Gradient descent over convex landscapes"
date = "April 2022"
abstract = "A note on the most elementary result of convex optimization: the speed of convergence is determined by the conditionning number of the Hessian. "
+++

A function $f$ is [convex](https://en.wikipedia.org/wiki/Convex_function) when $f(x) - f(y) \geqslant \langle \nabla f(y), x-y\rangle$; with this pretty loose definition, it can very well happen that two different points $x,y$ have the same value $f(x) = f(y)$. Finding a minimum of $f$ with gradient descent can then lead to very different behaviours. For smooth functions, we have more quantitative notions of convexity and they lead to convergence results for the gradient descent algorithm. 

## Quantitative convexity

The largest eigenvalues of the Hessian of $f$ determine the Lipschitz smoothness of $f$, while the smallest ones determine the strong convexity of $f$. More precisely, if $\lambda_{\min}(x), \lambda_{\max}(x)$ are the smallest and largest eigenvalues of $\nabla^2 f(x)$ (the Hessian of $f$ at point $x$, a square matrix), then by elementary arguments we have 
\begin{equation}
\lambda_{\min}(x)|v|^2 \leqslant \langle v, \nabla^2 f(x)v\rangle \leqslant \lambda_{\max}(x)|v|^2.
\end{equation}
But then, if we fix two vectors $x,y$, using Taylor's formulas yields the following result.

@@important
Let $f$ be a $\mathscr{C}^2$, convex function. If there are two numbers $0< \eta \leqslant M$ such that for every $x$, we have $\eta \leqslant \lambda_{\min}(x)$ and $\lambda_{\max}(x)\leqslant M$, then for every $x,y$, 
\begin{equation}\label{qc}
\langle \nabla f(x), y-x\rangle + \frac{\eta}{2}|x-y|^2  \leqslant f(y) - f(x) \leqslant \langle \nabla f(x), y-x\rangle + \frac{M}{2}|x-y|^2.
\end{equation}
@@

The lower bound is a stronger version of convexity; it is often called *$\eta$-strong convexity*. The second one is indeed nothing more than the fact that if the Hessian norm is bounded by $M$, then the gradient of $f$ is $M$-Lipschitz. We say that $f$ is $M$-smooth. 

## Convergence of the gradient descent dynamic

Strongly convex functions have a unique minimum, say $x$. The gradient descent algorithm for finding this minimum consists in following the steepest descent direction, given by the gradient of $f$, with a step size of $\varepsilon$: starting from $x_0$, this descent is written
$$ x_{n+1} = x_n - \varepsilon \nabla f(x_n).$$

@@important
**Theorem.**

If $f$ is $\eta$-strongly convex and $M$-smooth, and if the step size $\varepsilon$ is smaller than $1/M$, then for every $n$ we have
$$ |x_n - x|^2 \leqslant (1 - \varepsilon \eta)^n |x_0 - x|^2.$$
@@

**Proof**. Developing the euclidean norm and using the LHS of \eqref{qc} with $y = x_n$, we get
\begin{align}|x_{n+1} - x|^2 &= |x_n - \varepsilon \nabla f(x_n) - x|^2 \\ &= |x_n - x|^2 - 2\varepsilon \langle \nabla f(x_n), x_n - x\rangle  + \varepsilon^2 |\nabla f(x_n)|^2 \\
&\leqslant |x_n - x|^2 + 2\varepsilon(f(x) -f(x_n))  - \eta \varepsilon|x-x_n|^2 + \varepsilon^2 |\nabla f(x_n)|^2 \\
&\leqslant |x_n - x|^2 (1 - \eta \varepsilon) + z
\end{align}
where $z = \varepsilon^2|\nabla f(x_n)|^2 - 2\varepsilon(f(x_n) - f(x))$. Now we only have to check that $z$ is nonpositive; if so, we will obtain $|x_{n+1} - x|^2 \leqslant |x_n -x|^2 (1 - \eta \varepsilon)$ and a recursion will finish the proof. 

**Proof of $z\leqslant 0$**. By the RHS of \eqref{qc} and the definition of $x_{n+1}$,  

$$ f(x_{n+1}) - f(x_n) \leqslant  -\varepsilon |\nabla f(x_n)|^2 + \frac{\varepsilon^2 M}{2}|\nabla f(x_n)|^2 = \varepsilon |\nabla f(x_n)|^2 ( \varepsilon M/2-1)$$
but then, if $\varepsilon M \leqslant 1$, the RHS is smaller than $-\varepsilon/2 |\nabla f(x_n)|^2$. Overall, we get that
$$ \varepsilon |\nabla f(x_n)|^2 \leqslant 2(f(x_n) - f(x_{n+1})) \leqslant 2(f(x_n) - f(x)) $$
or equivalently $z\leqslant 0$. 

---

There are several takeaway messages in this elementary but powerful result. 

- Having a step size $\varepsilon$ smaller than the Lipschitz constant $M$ is mandatory to get something meaningful. Otherwise, if the step size is too large, we could take steps that are consistently too big and overshoot the minimum at every step.

- We don't need $f$ to be smooth, only that $f$ is $\eta$-strongly convex and $M$-smooth, or equivalently that \eqref{qc} holds. 

- Reaching a point at a distance smaller than $\delta$ from the minimum $x$ will need a number of steps of order $\approx  \kappa \ln(1/\delta)$ with $\kappa = M/\eta$. 

- This quantity $\kappa$ can be interpreted as a « global » conditionning number of the Hessian of $f$: indeed, the conditionning of the Hessian at every point is smaller than $\kappa$. The smaller $\kappa$, the faster the convergence. Elementary preconditioning methods consist in replacing the objective function $f$ by $x\mapsto f(P x)$ for some matrix $P$. The function stays strongly convex and smooth, but the gradient is $P\nabla f(Px)$ and the Hessian is $P\nabla^2 f(Px)P^*$; a careful choice of $P$ will really reduce the conditionning of the problem.  

- When $f(x) = |Ax - b|^2 / 2$, we are doing nothing more than an iterative method to find a solution for $Ax = b$. The gradient of $f$ is $Ax$, while the Hessian is $A$: it no longer depends on $x$. Its eigenvalues are the eigenvalues of $A$, hence $\kappa$ is *really* the conditioning number of $A$. 



