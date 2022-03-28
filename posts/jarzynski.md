+++
titlepost = "The Jarzynski estimator"
date = "March 2022"
abstract = "An elegant estimator for free energies."
+++

We have a family of potentials $V_t$ on $\mathbb{R}^n$, evolving with time, and their associated Gibbs measures $p_t$, ie 
\begin{align*} &p_t(x) = \frac{e^{-V_t(x)}}{Z_t}&& \text{where}&& Z_t = \int_{\mathbb{R}^n} e^{-V_t(x)}dx.\end{align*}
The goal is to compute, at least numerically, the partition functions $Z_t$ or equivalently the free energy $F_t = - \log Z_t$. In many problems, the family of potentials  $(V_t)$ connects an unknown potential $V_0$, for which we would like to compute $F_0$, and another potential $V_1$ for which $F_1$ is known.   

An elegant way of estimating these free energies uses the *Jarzynski identity*, discovered in 1996. It is based on the Langevin dynamics associated with the evolving potential $V_t$:
\begin{equation}\label{sde}dX_t = - \nabla V_t(X_t)dt + \sqrt{2}dW_t \end{equation}
with $(W_t)$ a Brownian motion. 
Upon standard conditions on $V_t$, this system -- a standard Stochastic Differential Equation -- has a solution. Note that the distribution of $X_t$ is *not* $p_t$ in general. However, there is a remarkable identity relating the distribution of $X_t$ with $p_t$.   
@@important
**Jarzynski's identity** states that 
$$\mathbf{E}[e^{-\int_0^t \dot{V}_s(X_s) - \dot{F}_sds}] = 1. $$
@@
Here and after, the dot in $\dot{V}_t$ or $\dot{F}_t$ always represents a derivative with respect to time. 

The consequence  of this identity is that 
$$ \log \mathbf{E}[e^{-\int_0^t \dot{V}_s(X_s)ds}] = F_t - F_0, $$
giving rise to a natural estimator for the *free energy difference* $F_t-F_0$: one samples many paths from the dynamics \eqref{sde}, then computes the path integral $w_t = \int_0^t \dot{V}_s(X_s)ds$ along each path, and then average the values of $e^{-w_t}$ and take the log. 




## A proof of Jarzynski's identity

### Overview

In general, exponential of paths integrals are not easy to study. The classical way is to use the [Feynman-Kac](https://en.wikipedia.org/wiki/Feynman%E2%80%93Kac_formula) representation of PDEs, but this proof seems quite involved; instead, there is a nice trick shown to me by Eric Vanden-Eijnden. The trick is as follows: if $\rho_t(x,y)$ is the probability density of the system $(X_t, e^{-\int_0^t \dot{V}_s(X_s) - \dot{F}_sds})$ at $t$, then 
- clearly, we want to compute $\int u \rho_t(x,u)dudx$, 
- the quantity $a_t(x) = \int u \rho_t(x,u)du$ solves an explicit equation, 
- and from this equation we can see that $a_t(x) = e^{-V_t(x)}/Z_t = p_t(x)$.  
The proof is then finished, since $\int a_t = \int p_t = 1$. From now on, we'll set $U_t = V_t - F_t$, so that $p_t(x) = e^{-U_t(x)}$. Clearly, $\nabla U_t = \nabla V_t$. 

### The augmented system

We set
$$ \begin{cases}dX_t = - \nabla U_t(X_t)dt + \sqrt{2}dW_t \\ dI_t = -\dot{U}_t(X_t)I_t\end{cases}$$
subject to the starting condition $I_0=1$ and $X_0 \sim p_0$. Then
clearly, $$ I_t = e^{-\int_0^t \dot{U}_s(X_s)ds}. $$

We consider the system $Z_t=  (X_t, I_t)$ as a single SDE $d Z_t = f(t,Z_t)dt + \sigma dW_t$ with 
\begin{align*}&f_t(x,y) = \begin{pmatrix} - \nabla U_t(x) \\ -\dot{U}_t(x)y \end{pmatrix} &&\text{ and }&& \sigma = \mathrm{diag}(\sqrt{2}, \dotsc, \sqrt{2}, 0).\end{align*}
Let us note $\rho_t(x,y)$ the density of $(X_t, I_t)$, and write the associated [Fokker-Planck](https://en.wikipedia.org/wiki/Fokker%E2%80%93Planck_equation) equation; here and after, $\nabla$ is a gradient and $\nabla \cdot$ is the divergence, ie $\nabla \cdot \varphi = \sum_i \partial_i \varphi$. Subscripts denote partial differentiation with respect to some variables. 

\begin{align*}\dot{\rho}_t &= -\nabla \cdot  \left[ f_t\rho_t \right] + \frac{\sigma^2}{2}\Delta \rho_t\\
&= - (\nabla \cdot f_t) \rho_t - f_t \cdot  \nabla \rho_t + \Delta_x \rho_t \\
&= - (\nabla_x \cdot f_t) \rho_t - (\nabla_y \cdot f_t)\rho_t - f_t \cdot  \nabla \rho_t + \Delta_x \rho_t \\
&=- (\nabla \cdot \nabla U_t) \rho_t + \dot{U}_t\rho_t - f_t \cdot \nabla \rho_t  + \Delta_x \rho_t\\
 \end{align*}

### The marginal integration

 Set $a_t(x) = \int_0^\infty y \rho_t(x,y)dy$, so that $\mathbf{E}[I_t] = \int a_t(x)dx$. Multiplying the last equation by $y$, integrating, and swapping integrals and derivatives, we get 
 \begin{align*}\dot{a}_t &= \int y \dot{\rho}_t(x,y)dy \\
 &= - (\nabla \cdot \nabla U_t) a_t + \dot{U}_t a_t - \int y (f_t \cdot \nabla \rho_t)  + \Delta a_t
 \end{align*}
 We have $f_t \cdot \nabla \rho_t = - \nabla U_t \cdot \nabla_x \rho_t - \dot{U}_t y \nabla_y \rho_t$, hence 
$$\dot{a}_t =  - (\nabla \cdot \nabla U_t) a_t + \dot{U}_t a_t + \nabla U_t \cdot \nabla a_t   + \dot{U}_t \int y^2 \partial_y \rho_t(x,y)dy+ \Delta a_t. $$

 An integration by parts shows that $\int y^2 \partial_y \rho_t(x,y)dy = -2 \int y \rho_t(x,y)dy = -2a_t$, providing a sufficient decay of $y \to y^2 \rho(x,y)$ at infinity. We obtain the following equation:
 \begin{equation}\label{fp} \dot{a}_t = -(\nabla \cdot \nabla U_t)a_t - \dot{U}_t a_t + \nabla U_t \cdot \nabla a_t + \Delta a_t.\end{equation}
 It turns out that the density $p_t(x) = e^{-U_t(x)}$ is the solution of this equation. Indeed, $p_t = - \dot{U}_t p_t$ and $\nabla p_t = -\nabla U_t p_t$, so that it is easy to check that \eqref{fp} is satisfied. Moreover, $a_0(x)= \int y \rho_0(x,y)dy = e^{-U_0(x)} = p_0(x)$, so the initial conditions are identical.  

 To conclude, we obtain
 $$\mathbf{E}[I_t] = \int a_t(x)dx = \int p_t(x)dx = 1.$$

 ## References

 - [Jarzynski's paper](https://arxiv.org/abs/cond-mat/9610209), written in 1996.