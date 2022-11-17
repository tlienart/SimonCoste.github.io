+++
titlepost = "Stirling"
date = "November 2022"
abstract = "Robbin's version of Stirling's approximation."
+++

The most beautiful formula in mathematics is certainly not the triviality $1 + e^{i\pi}=0$, as claimed by many tasteless mathematicians, but rather *Stirling's formula*, stating that $n!\sim n^n e^{-n}\sqrt{2\pi n}$. Quantifying the error of this approximation can be done to any precision using the Euler-MacLaurin disgusting formula, but it is often handy to have a simpler estimation; Robbin's one (original paper [here](https://www-fourier.ujf-grenoble.fr/~marin/une_autre_crypto/articles_et_extraits_livres/Robbin_H.-A_remark_on_Stirling%5C's_Formula.pdf)) is surprisingly accurate. It goes like this: 
\begin{equation}
e^{\frac{1}{12n + 1}} < \frac{n!}{n^n e^{-n} \sqrt{2\pi n}} < e^{\frac{1}{12n}}.
\end{equation}

## Proof

We have $\ln(n!) = \sum_{k=1}^{n-1} \ln(k+1)$. Robbin's analysis consists in a subtle approximation of $\ln(k+1)$, as seen as the area of the rectangle $[k,k+1] \times [0, \ln(k+1)]$. This area is equal to: 
- the area $I_k$ of the points in the rectangle under the curve $\ln(x)$, that is $\int_k^{k+1}\ln(x)dx$, 
- plus the area $T_k$ of the triangle between the points $(k,\ln(k)), (k, \ln(k+1)), (k+1, \ln(k+1))$, 
- minus the area $\delta_k$ of the small zone we counted twice, which is equal to $I_k$ minus the area of the points in the rectangle that are not in the preceding triangle. 

Clearly, $T_k = (\ln(k+1) - \ln(k))/2$. We also recall that the antiderative of $\ln(x)$ is $x\ln(x) - x$. Consequently, noting $S_n = \delta_2 + \dotsb + \delta_{n-1}$, 
\begin{align}\ln(n!) &= I_2 + \dotsb + I_{n-1} + T_2 + \dotsc + T_{n-1} - S_n\\
&= \int_1^n \ln(x)dx + \frac{1}{2}\ln(k) - S_n\\
&= n\ln(n) - n + 1 + \frac{1}{2}\ln(n) - S_n.
\end{align}

## Estimating $S_n$

How would be estimate $S_n$? Well, first we can compute the $\delta_k$: they are equal to $I_k$ minus the area of the trapezoidal approximation of $I_k$, which is $(\ln(k) + \ln(k+1))/2$: 
\begin{align}\delta_k &= \int_k^{k+1}\ln(x)dx - \frac{ln(k) + \ln(k+1)}{2}\\
&= (k+1)\ln(k+1) - (k+1) - k\ln(k) + k - \frac{\ln(k) + \ln(k+1)}{2}\\
&=  -1 + \ln\left(\frac{k+1}{k}\right)(k + 0.5).
\end{align}

### Robbin's trick

Now you might want to develop the determinant as $\ln(1 + k^{-1})$. Don't do this. Instead, do the following dark magic: first, note that 
$$\frac{k+1}{k} = \frac{1 + x}{1-x}$$
where $x = (2k+1)^{-1}$. Then, use the analytic formula
$$\ln((1+x)/(1-x)) = 2\sum_{\ell = 0}^\infty \frac{x^{2\ell +1}}{2\ell +1}$$
so that
\begin{align} \delta_k &= -1 + \frac{1}{x}\left(x + \frac{x^3}{3} + \frac{x^5}{5} + \frac{x^7}{7} + \dotsb \right)\\
&= - \frac{x^2}{3} - \frac{x^4}{5} - \frac{x^6}{7} - \dotsb \\
&= - \frac{1}{3(2k+1)^2} - \frac{1}{5(2k+1)^4} - \dotsb
\end{align}
We now use this to bound $\delta_k$ below and above. 

### Upper bound

\begin{align}
- \delta_k &<  \frac{1}{3(2k+1)^2} + \frac{1}{3(2k+1)^4} + \dotsb \\&= \frac{1}{3(2k+1)^2}\frac{1}{1 - (2k+1)^{-1}}\\&= \frac{1}{6k(2k+1)}
\end{align}