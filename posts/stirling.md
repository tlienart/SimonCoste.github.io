+++
titlepost = "Robbins' version of the Stirling approximation"
date = "November 2022"
abstract = "A handy, easy-to-remember estimate for the error in Stirling's approximation."
+++

The most beautiful formula in mathematics is certainly not the triviality $1 + e^{i\pi}=0$, as claimed by many tasteless mathematicians with no self-esteem, but rather *Stirling's formula*, stating that $n!\sim n^n e^{-n}\sqrt{2\pi n}$. Quantifying the error of this approximation can be done to any precision using the [Euler-MacLaurin complicated formula](https://en.wikipedia.org/wiki/Euler%E2%80%93Maclaurin_formula), but it is often handy to have a simpler estimation; Herbert Robbins[^1] found one (original note [here](https://www-fourier.ujf-grenoble.fr/~marin/une_autre_crypto/articles_et_extraits_livres/Robbin_H.-A_remark_on_Stirling%5C's_Formula.pdf)) which is surprisingly accurate:

@@important
\begin{equation}\label{1}
e^{\frac{1}{12n + 1}} < \frac{n!}{n^n e^{-n} \sqrt{2\pi n}} < e^{\frac{1}{12n}}.
\end{equation}
@@
The inequalities are strict and valid for every $n$. 
The proof of this result is given below. For future reference, we can compare \eqref{1} with the higher-order expansion: 
$$ \frac{n!}{n^n e^{-n}\sqrt{2\pi n}} = \exp \left\lbrace \frac{1}{12n} - \frac{1}{360n^3} + \frac{1}{1260n^5} + O(\frac{1}{n^7}) \right\rbrace.$$

## Proof of \eqref{1}

We have $\ln(n!) = \sum_{k=1}^{n-1} \ln(k+1)$. Robbins' proof consists in a subtle approximation of $\ln(k+1)$, as seen as the area of the rectangle $[k,k+1] \times [0, \ln(k+1)]$. This area is equal to: 
- the area $I_k$ of the points in the rectangle under the curve $\ln(x)$, that is $\int_k^{k+1}\ln(x)dx$, (in the picture, it's the pink+black zone) 
- plus the area $T_k$ of the triangle between the points $(k,\ln(k)), (k, \ln(k+1)), (k+1, \ln(k+1))$, (blue+black zone)
- minus the area $\delta_k$ of the small black zone we counted twice, which is equal to $I_k$ minus the area of the points in the rectangle that are not in the preceding triangle. 

![sliver](/posts/img/robbins.svg)

Clearly, $T_k = (\ln(k+1) - \ln(k))/2$. We also recall that the antiderative of $\ln(x)$ is $x\ln(x) - x$. Consequently, noting $S_n = \delta_2 + \dotsb + \delta_{n-1}$, 
\begin{align}\label{eq1}
\ln(n!) &= I_2 + \dotsb + I_{n-1} + T_2 + \dotsc + T_{n-1} - S_n\\
&= \int_1^n \ln(x)dx + \frac{1}{2}\ln(k) - S_n\\
&= n\ln(n) - n + 1 + \frac{1}{2}\ln(n) - S_n.
\end{align}

### Estimating $S_n$

How big is $S_n$? Well, first we can reckon the $\delta_k$: they are equal to $I_k$ minus the area of the trapezoidal approximation of $I_k$, which is $(\ln(k) + \ln(k+1))/2$: 
\begin{align}\delta_k &= \int_k^{k+1}\ln(x)dx - \frac{\ln(k) + \ln(k+1)}{2}\\
&= (k+1)\ln(k+1) - (k+1) - k\ln(k) + k - \frac{\ln(k) + \ln(k+1)}{2}\\
&=  -1 + \ln\left(\frac{k+1}{k}\right)(k + 0.5).
\end{align}

### Robbin's trick

Now you might want to develop the determinant as $\ln(1 + k^{-1}) = k^{-1} + k^{-2}/2 + \dots$: **don't do this**. Instead, do the following dark magic: first, note that $\frac{k+1}{k} = \frac{1 + x}{1-x}$ where $x = (2k+1)^{-1}$. Then, use the analytic formula
$$\ln((1+x)/(1-x)) = 2\sum_{\ell = 0}^\infty \frac{x^{2\ell +1}}{2\ell +1}$$
so that
\begin{align} \delta_k &= -1 + \frac{1}{x}\left(x + \frac{x^3}{3} + \frac{x^5}{5} + \frac{x^7}{7} + \dotsb \right)\\
&= - \frac{x^2}{3} - \frac{x^4}{5} - \frac{x^6}{7} - \dotsb \\
&= - \frac{1}{3(2k+1)^2} - \frac{1}{5(2k+1)^4} - \frac{1}{7(2k+1)^6} - \dotsb
\end{align}
We now use this to bound $\delta_k$ below and above. 

### Upper bound
Since $3,5,7,9\dots$ are all greater than 3, 
\begin{align}
- \delta_k &<  \frac{1}{3(2k+1)^2} + \frac{1}{3(2k+1)^4} + \frac{1}{3(2k+1)^6} + \dotsb \\&= \frac{1}{3(2k+1)^2}\frac{1}{1 - (2k+1)^{-2}}\\&= \frac{1}{12k(k+1)}= \frac{1}{12k}\left(\frac{1}{k} - \frac{1}{k+1} \right).
\end{align}


### Lower bound

On the other hand, $3,5,7,9\dots$ are smaller than $3,3^2, 3^3, 3^4\dots$, so 
\begin{align}
-\delta_k &>  \frac{1}{3(2k+1)^2} + \frac{1}{3^2(2k+1)^4} + \frac{1}{3^3(2k+1)^6} + \dotsb \\&= \frac{1}{3(2k+1)^2}\frac{1}{1 - (3(2k+1))^{-2}}\\
&= \frac{1}{12((k+1/2)^2 - 1/12)}.
\end{align}
It turns out that $(k+1/2)^2 -1/12 < (k+1/12)(k+1/12 + 1)$ (develop both sides then dismiss some terms), so that 
$$-\delta_k > \frac{1}{12}\left( \frac{1}{k+1/12} - \frac{1}{k+1/12 + 1} \right).$$

### Adding up

From the preceding bounds we see that the series $\delta_1 + \delta_2 + \dotsb$ is indeed convergent. If $s$ is its sum, $S_n = s - \sum_{k>n}\delta_k$ and using again the precedings bounds (they are telescoping), we can estimate: 
$$ s - \frac{1}{12n}< S_n < s - \frac{1}{12n+1}$$
Now go back last line of \eqref{1}. Take exponentials to get $n!/n^n e^{-n}\sqrt{n} = e^{1-S_n}$. Then, with $c=1-s$ and the estimate above,
$$ e^{c + \frac{1}{12n+1}}<\frac{n!}{n^n e^{-n}\sqrt{n}}< e^{c + \frac{1}{12n}}.$$

### What about the constant ?

It's obviously not over, since we didn't get the constant $c$. This, however, is usually done by another means, typically with the Wallis integral asymptotics as they [here](https://en.wikipedia.org/wiki/Wallis%27_integrals#Deducing_Stirling's_formula). 


---

[^1]: Herbert Robbins does not have the fame he deserves. He's the Robbins of the Robbins-Munro algorithm, the Lai-Robbins bound on bandit algorithms, the backward algorithm for the secretary problem: three essential contributions to different domains of statistics and computational mathematics. His book *What is Mathematics ?* with Courant is a masterpiece. 



