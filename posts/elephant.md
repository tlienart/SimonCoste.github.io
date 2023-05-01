+++
titlepost = "The Elephant random walk"
date = "May 2023"
abstract = "Adding memory to diffusive processes "
+++
@@important
The Elephant starts at 0 and takes a first step $S_1=+1$ with probability $p_0$ or $S_1 = -1$ with probability $1-p_0$. Then, at time $n$, the Elephant randomly remembers a past step $S_m$, with $m$ uniformly distributed on $\{1, \dotsc, n\}$. With probability $p$ he reproduces the same step; otherwise he goes the opposite way. 
@@

@@important 
Set $W_0=0$ and $W_1 \sim \mathrm{Rademacher}(p_0)$. Let $U_k \sim \mathrm{Uniform}(\{1, \dotsc, k\})$ and $\varepsilon_k \sim \mathrm{Rademacher}(p)$ be two sequences of independent random variables; we set $W_{n+1} = W_n + \varepsilon_n S_{U_n}$. 
@@ 

## Computing the variance
$$V_{n+1}=\mathbf{E}[W_{n+1}^2] = \mathbf{E}[W_n^2 + 2S_{n+1}W_n + S_{n+1}^2]=V_n + 1 + 2\mathbf{E}[W_n\mathbf{E}[S_{n+1}\mid \mathscr{F}_n]].$$ 
Conditionnally on $\mathscr{F}_n$, the last jump $S_{n+1}$ is distributed as a Rademacher random variable with a certain parameter $p_n$. Let $N_n$ denote the number of +1 jumps before $n$; then $p_n = pN_n/n + (1-p)(n-N_n)/n$. Since $N_n = (n+W_n)/2$, we obtain
$$p_n = \frac{1}{n}\left(p\frac{n+W_n}{2} + q\frac{n-W_n}{2}\right) = \frac{n+(p-q)W_n}{2n}.$$
The expectation of a Rademacher random variable with parameter $p_n$ is $p_n - (1-p_n) = 2p_n -1$, hence
$$\mathbf{E}[S_{n+1}\mid \mathscr{F}_n] = (p-q)\frac{W_n}{n}.$$

@@important
The variance of the Elephant Randow Walk $V_n = \mathrm{Var}(W_n)$ satisfies the recursion
\begin{equation}\label{Vn}
V_1 = 1, \qquad\qquad V_{n+1} = 1 + \left(1 + \frac{2(p-q)}{n}\right)V_n.
\end{equation}
The explicit solution is given by
$$V_n = \frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)} \int_0^1 (1-x)^{(\alpha-1)-1} (1-x^n)dx.$$
@@
@@important
**Diffusive case**
If $p<3/4$, 
$$V_n \sim \frac{n}{3-4p}.$$
**Critical case**
If $p=3/4$, 
$$V_n \sim n\log(n).$$
**Super-diffusive case**
If $p>3/4$, 
$$V_n \sim \frac{n\times n^{4p-3}}{(4p-3)\Gamma(4p-2)}$$
@@

The integral there has a different behaviour according to the sign of $\alpha-1 = 4p-3$. We recall that $\Gamma(x) \sim x^{x}e^{-x}\sqrt{2\pi x}$, hence 
$$ \frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)} \sim \frac{(\alpha+n)^\alpha}{\Gamma(\alpha)}. $$
On the other hand, the integral part $I_n(\alpha)$ above has three asymptotic regimes according to the sign of $\alpha-1$. 
- If $\alpha-1>0$ then $I_n(\alpha)\sim \int_0^1 (1-x)^{\alpha-2}dx = (\alpha-1)^{-1}$;
- If $\alpha=1$ then $I_n(\alpha)=1+1/2+1/3 +\dotsb + 1/n\sim \log(n)$;
- If $\alpha-1<0$ then $I_n(\alpha)\sim \Gamma(\alpha)n^{-\alpha}n/(1-\alpha)$

@@proof
**Exact computation of the variance $V_n$.** 


Let us note $\alpha = 2(p-q)$ and $x_n = (n + \alpha)/n$ so that $V_{n+1} = 1 + x_n V_n$. Define $V'_n = V_n/c_n$ for $c_n = x_{n-1}x_{n-2}\times\dotsm\times x_2x_1$ (we chose $c_n$ so that $c_nx_n = c_{n+1}$). Then, 
$$ V'_{n+1} = \frac{1}{c_{n+1}} + \frac{V_n}{c_{n}}\frac{c_n x_n}{c_{n+1}} = \frac{1}{c_{n+1}} + V'_n.$$
By a telescoping sum and using $V'_1 = 1$, 
$$V'_{n} = \frac{1}{c_{n}} + \frac{1}{c_{n-1}} + \dotsb + \frac{1}{c_2} + 1.$$
Now we see that 
$$c_{n+1} = x_n x_{n-1}\times \dotsm \times x_1 = \frac{(\alpha+n)(\alpha+n-1)\times \dotsm \times (2+\alpha)(1+\alpha)}{n(n-1)\times \dotsm \times 2\times 1}= \frac{\Gamma(\alpha+n)}{\Gamma(n)\Gamma(\alpha+1)} $$ 
hence\begin{align}V'_{n} &= \sum_{k=1}^n \frac{\Gamma(k)\Gamma(1+\alpha)}{\Gamma(k+\alpha)}. \end{align}
Now since $V_n = c_n V'_n$, we get
\begin{align} V_n = \frac{\Gamma(\alpha+n)}{\Gamma(\alpha+1)\Gamma(n)}\sum_{k=1}^n\frac{\Gamma(k)\Gamma(1+\alpha)}{\Gamma(k+\alpha)} &= \frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)}\sum_{k=1}^n\frac{\Gamma(k)\Gamma(\alpha)}{\Gamma(k+\alpha)} \\
&=\frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)}\sum_{k=1}^n \int_0^1 x^{k-1}(1-x)^{\alpha-1}dx\\
&=\frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)} \int_0^1 (1-x)^{\alpha-1} \frac{1-x^n}{1-x}dx\\
&=\frac{\Gamma(\alpha+n)}{\Gamma(\alpha)\Gamma(n)} \int_0^1 (1-x)^{\alpha-2} (1-x^n)dx\\
\end{align}
where in the middle we used the link between the Gamma function and the Beta function. 
@@