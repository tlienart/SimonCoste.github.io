+++
titlepost = "Importance sampling ⚖️ "
date = "June 2023"
abstract = "Change-of-measure for out-of-equilibrium systems"
+++

*Sampling* refers to the generation of random variables following a certain probability distribution; for example if $\rho$ is a probability measure on $\mathbb{R}$, we want to generate random variables which are independent and follow the distribution given by $\rho$, or we want to compute expectations like $\mathbb{E}[\varphi(Y)]$ for some function $\varphi$, where $Y \sim \rho$. In many cases, one does not fully knows $\rho$, but only that it is proportional to some function $f$, that is $\rho(x) = f(x)/Z$ where $Z = \int f(u)du$, and computing $Z$ (the normalizing constant) is intractable. 

There are many techniques that still allow to sample from $\rho$ in this case; in this note I'm focusing on *importance sampling* (IS), also called *reweighting*. In this note I prove an insightful result by [Chatterjee and Diaconis](https://arxiv.org/pdf/1511.01437.pdf) on the number of samples required for IS to be sufficiently precise. 
## The basic idea of Importance sampling

Let $\nu$ be probability measure, easy to sample from, with density $g$. Let $Y \sim \rho$ and $X\sim \nu$ (in the sequel, $Y_i$ will always have density $\rho$ and $X_i$ density $g$). Then, for any function $\varphi$, 
$$ \mathbb{E}[\varphi(X)f(X)/g(X)] =  \int \varphi(x)\frac{f(x)}{g(x)}g(x)dx = \int \varphi(x)f(x)dx = Z \mathbb{E}[\varphi(Y)]. $$
Applying this formula to $\varphi \equiv 1$ also yields  $\mathbb{E}[f(X)/g(X)] =Z$. Consequently, 
$$\frac{ \mathbb{E}[\varphi(X)f(X)/g(X)] }{ \mathbb{E}[f(X)/g(X)] } = \mathbb{E}[\varphi(Y)].$$
This suggests the following method for approximating $\mathbb{E}[\varphi(Y)]$ without computing $Z$. 

@@important
Let $X_1, \dotsc, X_n$ be iid with law $\nu$. Set $w(x) = f(x)/g(x)$. Then, when $n\to\infty$, almost surely one has
\begin{equation}\label{Z} \frac{\sum_{i=1}^n w(X_i)}{n} \to Z \end{equation}
and
\begin{equation}\label{In} \frac{\sum_{i=1}^n w(X_i) \varphi(X_i)}{\sum_{i=1}^n w(X_i)} \to \mathbb{E}[\varphi(Y)]= \int \Phi(x)\frac{f(x)}{Z}dx.\end{equation}
@@

@@proof
**Proof.** By the Law of Large Numbers, the LHS of \eqref{Z} converges towards $\mathbf{E}[w(X)] = \int w(x)g(x)dx = \int f(x)dx = Z$. 

Also by the LLN, $\frac{\sum w(X_i)\varphi(X_i)}{n}$
converges towards $\mathbf{E}[\varphi(X)w(X)] = Z\mathbf{E}[\varphi(Y)]$. 

Take the ratio of the two to get \eqref{In}. 
@@
This technique explains the word *importance sampling*: the samples $X_i$ are iid but their density is $g(x)$, not $f(x)/Z$, and the weights correct the difference between the two. If some $x$ is very likely under $g$ but not so much under $f$ (meaning that $f(x)/Z$ is close to zero but $g(x)$ is high), then this sample will be assigned a very small weight. 

## How good is this approximation? 

Unless $\rho$ and $\nu$ are already very close to each other, this can be pretty bad. Let's look at the variance of the estimator $\hat{Z}$ given in \eqref{Z}: clearly $\mathbf{E}[\hat{Z}]=Z$, hence
$$ \mathrm{Var}(\hat{Z}) = \frac{\int g(x) \frac{f(x)^2}{g(x)^2}dx - Z^2}{n} = \frac{\int f(x) \frac{f(x)}{g(x)}dx - Z^2}{n} = \frac{Z\mathbf{E}[f(Y)/g(Y)]-Z^2}{n}.$$
The first term could be prohibitively big. Indeed, let us consider the following situation: our prior density is a Standard Gaussian $g(x) = e^{-x^2/2}/\sqrt{2\pi}$, and our target density is the same, but shifted by 10: $f(x) = e^{-(x-10)^2/2}/\sqrt{2\pi}$. Here both densities are normalized, so $Z=1$. But, 
$$\mathbf{E}[f(Y)/g(Y)] = \frac{1}{\sqrt{2\pi}}\int e^{-\frac{(x-10)^2}{2}}e^{-\frac{(x-10)^2 }{ 2} + \frac{x^2}{2}}dx = \frac{1}{\sqrt{2\pi}}\int e^{- \frac{(x-20)^2}{2} + 100}dx = e^{100}.$$
That is too big. Having a low variance for $\hat{Z}$ would require having more than $e^{100}$ samples, which is impossible. 

### The Effective Sample Size

Practically, a good indicator of the quality of our importance sampling is given by the *effective sample size*. Suppose you used $n$ samples $X_i$. If they were distributed exactly as $\rho$, that is if $g$ was proportional to $f$, we would have $w(X_i) = 1/Z$ for all $X_i$. In general $f$ is not proportional to $g$ hence that's not the case and one way to measure how far the samples we have are from $n$ samples of $\rho$, we set $\hat{\sigma}_n$ = the [empirical coefficient of variation](https://en.wikipedia.org/wiki/Coefficient_of_variation) of the $w(X_i)$, and 
$$ \mathrm{ESS}(n) = \frac{n}{1 + \hat{\sigma}_n}.$$

### How to use the ESS ? 

Suppose that you use IS with a sample size of $n=1000$. If $\mathrm{ESS} \approx 1000$ then the weigths are almost constant and there's a good chance that our sampling is excellent. If it's small, say $\mathrm{ESS} \approx 100$, then it means that the quality of your IS estimator is the same as if you would have used 100 samples of the real distribution $\rho$. 

This method is a good *rule of thumb* to assess the quality of IS, but it's quite empirical. In general, what is the required number of samples when one wants to efficiently estimate a mean $\mathbf{E}[\varphi(Y)]$ using importance sampling? 

## The number of samples required for IS

Let $$D = d_{\mathrm{KL}}(f\mid g) = \int \log (f(x)/g(x)) f(x)dx$$ be the Kullback-Leibler divergence from $\rho$ to $\nu$ (it is supposed to be $<\infty$). It can also be defined as $D=\mathbf{E}[\log w(Y)]$. In general, concentration inequalities allow to bound how much $\log w(Y)$ is concentrated around its mean $D$: depending on $\nu,\mu$, the deviation probability
\begin{equation}r(s)=\label{dev}\mathbf{P}(|\log w(Y) - D| > s)\end{equation}
should be a decreasing function of $s$ with $r(s)\to 0$. The error terms in the sequel will be expressed using this function $r$. Roughly speaking, $r(s)$ is very small. Note that I chose the two-sided deviation probability, mostly for simplicity. 

For any function $\varphi$ we'll note $J_n(\varphi)$ the estimator on the RHS of \eqref{In}, that is
$$ J_n(\varphi) = \frac{\sum_{i=1}^n w(X_i) \varphi(X_i)}{\sum_{i=1}^n w(X_i)}. $$
 We also note $I(\varphi) = \int \varphi(x)\rho(x)dx = \mathbf{E}[\varphi(Y)]$ the integral and $|\varphi|^2_2 = \int \varphi(x)^2 \rho(x)dx$ the L2-norm.




@@important
**Theorem ([Chatterjee and Diaconis, 2015](https://arxiv.org/pdf/1511.01437.pdf)).**


Let $s$ be any positive integer and $\varepsilon(s) = (e^{-s/4} + 2\sqrt{r(s/2)})^{1/2}$. 

*Positive part*. Suppose that $n=e^{D+s}$.  Then, for any $\varphi$, 
\begin{equation}\label{main}\mathbf{P}(|J_n(\varphi) - \mathbf{E}[\varphi(Y)]|>\varepsilon(s) |\varphi|_2)\leqslant 2\varepsilon(s).\end{equation}
*Negative part*. Conversely if $n=e^{D-s}$, there is a function $\varphi$ such that $\mathbf{E}[\varphi(Y)]\leqslant r(s/2)$ but $$\mathbf{P}(J_n(\varphi)=1) \geqslant 1 - e^{-s/2}.$$ 
@@

The proof almost entirely relies on the following lemma, in which we have set $I_n(\varphi)= \frac{\sum_{i=1}^n \varphi(X_i)w(X_i)}{nZ}$. 

@@important
**Lemma.** For any $\lambda >0$,
\begin{equation}\label{lem}\mathbf{E}[|I_n(\varphi) - I(\varphi)|] \leqslant |\varphi|_{2}\left(\sqrt{\frac{\lambda}{n}} + 2\mathbf{P}(w(Y)>\lambda)\right). \end{equation}
@@

As noted earlier we have $\mathbf{E}[\log w(Y)] = \int f(x)\log(f(x)/g(x))dx = D$, hence it is natural to choose $\log \lambda$ at the same scale as $D$. We take $\lambda = e^{D + s/4}$. The ratio $\lambda/n$ becomes $e^{-s/4}$ and $\mathbf{P}(w(Y)>\lambda)=r(s)$. Overall, the RHS of \label{lem} becomes equal to $ |\varphi|_2 \times \varepsilon(s)^2 $ where
$$ \varepsilon(s) = \sqrt{e^{-s/4} + r(s)}.$$

We will prove this lemma later. From now on, let us prove the theorem. 

@@proof 
**Proof of the positive part.**
Apply Markov's inequality and the Lemma to the constant function $1$ and to the function $\varphi$. We get 
\begin{align}\label{events}
&\mathbf{P}(|I_n(1) - 1|>\delta) \leqslant \varepsilon(s)^2/\delta &&\text{and}&&\mathbf{P}(|I_n(\varphi) - I(\varphi)|>\delta') \leqslant |\varphi|_2 \varepsilon(s)^2/\delta'.\end{align}
If $|I_n(1)-1|<\delta$ and $|I_n(\varphi) - I(\varphi)|<\delta'$ then we see that 
\begin{align}|J_n(\varphi) - I(\varphi)| = |I_n(\varphi)/I_n(1) - I(\varphi)|&\leqslant \frac{|I_n(\varphi) - I(\varphi)| + |I(\varphi)||I_n(1)-1|}{|I_n(1)|} \\
&\leqslant \frac{\delta' + \delta I(\varphi)}{1-\delta} \end{align}
Now choose $\delta = \varepsilon(s)$ and $\delta' = |\varphi|_2 \varepsilon(s)$. The probability of having at least one of the two events in \eqref{events} is smaller than $2\varepsilon(s)$ by the union bound. Moreover, since $|I(\varphi)|\leqslant |\varphi|_2$ by the Cauchy-Schwarz inequality, we get that 
$$\frac{\delta' + \delta |I(\varphi)|}{1-\delta}\leqslant \frac{2\varepsilon(s)|\varphi|_2}{1 - \varepsilon(s)} $$
and the result holds. 
@@

@@proof 
**Proof of the negative part.**
Use the Lemma with $\lambda = e^{D - s/2}$ and set $\varphi(x) = \mathbf{1}_{w(x)\leqslant \lambda}$, so that $I(\varphi) = \mathbf{P}(w(Y)\leqslant \lambda) \leqslant r(s/2)$. By the Markov inequality,  $\mathbf{P}(w(Y)>\lambda) \leqslant \mathbf{E}[w(Y)]/\lambda = 1/\lambda$. If every $X_i$ has $w(X_i)\leqslant \lambda$, then clearly $J_n(\varphi)=1$. By the union bound we thus have 
$$ \mathbf{P}(J_n(\varphi)\neq 1) \leqslant \sum_{i=1}^n \mathbf{P}(w(X_i)>\lambda) \leqslant \frac{n}{\lambda}=e^{-s/2}.$$

@@

## Proof of the Lemma

Set $\psi = \varphi \mathbf{1}_{w(x)\leqslant \lambda}$. Then, 
$$ |I_n(\varphi) - I(\varphi) |\leqslant | I_n(\varphi) - I_n(\psi) |+| I_n(\psi) - I(\psi)| + |I(\psi) - I(\varphi)| = A+B+C$$

**-- Term $C$** is equal to $\int \rho(x)\varphi(x)\mathbb{1}_{w(x)> \lambda}dx$. By the Cauchy-Schwarz inequality it is smaller than 
\begin{equation}\label{p:2} \sqrt{\int \varphi(x)^2 \rho(x)dx \times \mathbb{P}(w(Y)> \lambda)} = |\varphi|_{2}\sqrt{\mathbb{P}(w(Y)> \lambda)}.\end{equation}
**-- Term $B$** is smaller than $ \frac{1}{nZ}\sum w(X_i)|\varphi(X_i)| \mathbf{1}_{w(X_i)>\lambda}$ hence its expectation is smaller than $\mathbb{E}[w(X)|\varphi(X)|\mathbf{1}_{w(X)>\lambda}]/Z = \mathbb{E}[\varphi(Y)\mathbf{1}_{w(Y)>\lambda}]$ and we use the same trick as \eqref{p:2}. 

**-- Term $A$** is bounded as follows: 
\begin{align}
\mathbf{E}[|I_n(\psi) - I(\psi)|]&\leqslant  \sqrt{\mathbf{E}[|I_n(\psi) - I(\psi)|^2]} = \mathrm{Var}(I_n(\psi))\\
&\leqslant\sqrt{\frac{\int \psi(x)^2w(x)^2g(x)dx}{nZ} }\\
&\leqslant \sqrt{ \frac{\int_{w(x)\leqslant \lambda} \varphi(x)^2 w(x) f(x) dx}{n Z}}\\
&\leqslant \sqrt{\lambda \frac{\int \varphi(x)^2 \rho(x) dx}{n} } = \sqrt{\lambda |\varphi|^2_{2}/n}.\\
\end{align}
We gather the three bounds and get \eqref{lem}. 



# Reference

- [The paper](https://arxiv.org/pdf/1511.01437.pdf) by Chatterjee and Diaconis, with a very nice application to an old remark by Knuth on self-avoiding walks. 

- [A nice paper on the Effective Sample Size](https://www2.stat.duke.edu/~scs/Courses/Stat376/Papers/ConvergeRates/LiuMetropolized1996.pdf) by Jun S Liu, with a theoretical justification on why the ESS is significant and a comparison with other sampling techniques. 


