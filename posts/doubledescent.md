+++
titlepost = "The double descent phenomenon"
date = "November 2021"
abstract = "Why do overparametrized networks do well?"
+++

## Machine learning, the summary

**Neural networks** are functions $f_\theta$ built by combining linear and non-linear functions; they depend on a certain number of parameters $\theta= (\theta_1, \dotsc, \theta_P)$. *Learning* consists in finding the best set of parameters $\theta_{\mathrm{opt}}$ for performing a precise task - for instance translating text or telling if it's a cat or a dog in the photo. 

![](/posts/img/catsanddogs.svg)

In *supervised learning*, this is done by learning this task, say $f$, on a set of examples $(x_i, y_i)$ where $x_i$ is an input and $y_i = f(x_i)$ the output related to the input. We try to find $\theta$ such that $f_\theta(x_i) \approx y_i$ for all the examples at our dispositions: this is called **interpolation**. Once this is done, we hope that $f_\theta$ did not only learn the examples, but that when confronted to unseen examples $(x,y)$, the predicted output $\hat{y}=f_\theta(x)$ will be very close to the real output $y = f(x)$. This is called **generalization**. 


## The tradeoff between learning and understanding 

### Old school learning: overfitting vs generalizing

There's a tradeoff between interpolation and generalization. If we want a function to perfectly interpolate the data, that is, $f_\theta(x_i) = y_i$, then there's a risk of choosing $f_\theta$ too complicated given the data, and unrealistic. 

@@important 

For instance, suppose we want to interpolate the green points in the figure below - these points are 0 plus a very small noise. There is a big difference between:
- the best linear approximation (blue curve, here $\theta = (\theta_0, \theta_1)$ and $f_{\theta}(x) = \theta_0 + \theta_1 x$) 
- the best degree-6-polynomial approximation (orange line, here $\theta=(\theta_0, \dotsc, \theta_6)$ and $f_\theta(x) =  \theta_0 + \theta_1 x + ... + \theta_P x^P$):

![](/posts/img/fitting.png)
Intuitively, the second approximation (degree 6 polynomials) is more complex than the first one, so it fits better the data, but it probably not captured the phenomenon which created the green points. If I draw another green point (ie, a random Gaussian number with a small variance), there's a good chance that the orange line will be completely off, but not the blue one.
@@

This phenomenon has been known for long; in classical statistics, it's called the bias-variance tradeoff. In short, *when the complexity of $f_\theta$ increases, we should first have a better fitting of the training data and a better generalization (the model is better), but at some point, adding complexity to $f_\theta$ will fit the data too much and will not generalize well to unseen examples (the model is worse)*. This is called **overfitting**.

### Deep learning overfits and generalizes

The unsettling thing with deep learning is that this is not the end of the story, and there is something beyond overfitting: with modern neural network architectures, the generalization error first decreases with the number of parameters, then increases just as explained above, and then, when the number of parameters becomes huge (*heavily overparametrized regime*), the generalization error decreases again. **In the end, networks with a number of parameters well beyond the number of examples perform extremely well**, that's one of the main successes of deep learning. 


This *double descent phenomenon* in deep learning was discovered in 2018, see the [original paper](https://arxiv.org/pdf/1812.11118.pdf) by Belkin et al., and was extensively explored after. An overview of all the double descent curves found when training huge networks (such as ResNets) on image processing tasks can be seen in [OpenAI's paper on the topic](https://arxiv.org/pdf/1912.02292.pdf).
For instance, here is their double descent curve when training [ResNet18](https://pytorch.org/hub/pytorch_vision_resnet/) (the number of parameters is $\approx 10^6$) on CIFAR10:
![](/posts/img/modeldd.svg)
The green curve is the interpolation error: unsurprisingly, it monotonously decreases, since the network better fits the images in the train set, and quickly reaches zero, a point at which the training data are perfectly interpolated. The blue curve is the test error, and increases again in the overfitting phase, but then decreases again even though the training error already vanished.

## Why? The random features model

In short, there is no theoretical explanation for the double descent phenomenon, but there are some toy models in which the key features of double descent appear. [Belkin, Hsu and Xu](https://arxiv.org/abs/1903.07571) introduced some linear models and Fourier models, but the absence of non-linearities made the analogy with what happens in deep learning dubious. More recently, the paper by [Mei and Montanari (2019)](https://arxiv.org/abs/1908.05355) rigorously showed the double descent phenomenon for the Random Features model, and this is what I'll be presenting now. 

### The task

The underlying task to be learned is $f(x) = \langle \beta, x\rangle + \mathrm{noise}$, where the inputs $x$ are $d$-dimensional ($d=100$ for the rest of the note) and $\beta$ is a unit vector in $\mathbb{R}^d$ chosen beforehand and fixed forever. The noise can be chosen Gaussian with a small standard error of $\epsilon = .001$. 

For the set of examples, we will draw some random inputs $x_i$ on $\mathbb{R}^d$ and we will have at our disposition the corresponding outputs $y_i=f(x_i)$. The number of training examples will be fixed to $300$. 

```julia
d = 100 ; n = 300 ; ϵ = .001
β = randn(1, d)
x = randn(d,n)
y = sum(β.*x, dims=1) + 0.01 .* randn(1, n)
```

### The shape of interpolating function

We try to learn $f$ by approximationg with functions that look like this:   
$$f_\theta (x) = \sum_{i=1}^P \theta_i \sigma(\langle a_i, x \rangle)$$
where $\sigma$ is a nonlinearity (typically, a ReLu), the $a_i$ are $P$ elements of $\mathbb{R}^d$ called *features* and the $\theta_i$ are $P$ real numbers. 

In theory, we should learn the best possible $a_i$ and $\theta_i$, but this is mathematically too hard to analyze, so we simplify the problem: we will only learn $\theta = (\theta_1, \dotsc, \theta_P)$; the $a_i$ will be chosen at random and fixed forever. This is called the **random feature regression**.  

In order to see how regularization affects the problem, we also use a ridge penalty of strength $\lambda$, so that our learning process consists in minimizing the function
$$ \ell(\theta) = \sum_{i=1}^n (f_\theta(x_i) - y_i)^2 + \lambda |\theta|^2.$$ 
This problem has a unique minimizer given by $$θ_{\text{opt}} = y^\top Z^\top (ZZ^\top + \lambda I)^{-1}$$ where $Z = (\sigma(\langle a_i, x_j\rangle) \in \mathbb{R}^{P \times n}$. 

Now, if we choose a number of parameters $p$, we immediately have our optimal parameters $\theta_{\text{opt}}$ for learning the task given above through the examples `x,y`. 
Once we have this solution, we can compare $f_{\theta_{\text{opt}}}$ with the real model $f$. What we want to compute is nothing else than the error done on a new realization of $x$, that is, 
$$\mathbf{E}_x[(f_{\theta_\star}(x) - f(x))^2]$$
where $x$ is drawn at random. What Mei and Montanari did is to compute this quantity --- or rather, its limit in the large-dimensional regime. The formula is really involved, but we can estimate the error by drawing many realizations of $X$ and averaging over (say) 10000 realizations. We also try several ridge parameters $\lambda$. 

```julia
function compute_test_error(x, y, p, λ)

    RF = randn(p,d) #random feature matrix with p features

    Z = relu.(RF*x)
    θ_opt = y * transpose(Z) * inv( (Z*transpose(Z)) + (λ*n/d).*I) ./ n

    x_test = randn(d, 10000)
    y_test = sum(β.*x_test, dims=1) + 0.01 .* randn(1, 10000)
    y_pred = sum(θ_opt.*relu(RF.*x), dims=1)

    return sum(y_test - y_pred)^2 ./ 10000

end
```

And now, let's plot this test error for a wide range of $P$ and various ridge parameters $\lambda$. The y-axis is the test error in (4), averaged over 10 runs, as a function of the relative number of parameters per training samples $P/n$; I took $n = 300$ so the max number of parameters is approximately $1200$. The interpolation threshold happens at $P/n=1$, that is, when the number of features is equal to the number of training samples.    

![ridge](/posts/img/ridge.svg)

Note that the double descent becomes milder when the ridge parameter $\lambda$ grows. In fact, ridge penalizations as in (2) were precisely designed to avoid overfitting, by penalizing the parameters which are too high. On the other side, when $\lambda \to 0$, the ridge regression approaches the classical linear regression, and it can be shown that the test error at the interpolation threshold $P/n=1$ goes to $\infty$ - a simple computation done in Belkin's original paper.

The interesting aspect of this experiment is not only that we see the double descent, but that it's actually provable - there is a function $F$ of the number of parameters such that the error with $p$ parameters is asymptotically close to $F(p)$ when $n$ goes to $\infty$ (in a certain regime, though, where $d$ is proportional to $n$).


  
## A wild guess

The task we tried to learn is the simplest one: $f$ is linear. A simple linear regression would have done the job very well: in fact, adding the non-linearities $\sigma$ only complicated the learning of $f$. 

The double descent curve might come from the fact that the complexity of our models is *well too high* for the task we try to learn. And if so, then maybe classical image recognition tasks like cats & dogs or MNIST are indeed way easier than we think, and highly complex ResNets architectures are way too complicated for them - but finding the exact, simple architecture suited for these tasks might also be out of reach for the moment.   

## References


- The first motivated studies of the double descent phenomenon are due to Belkin and his team, notably in [this paper](https://arxiv.org/abs/1903.07571) and [this one](https://arxiv.org/abs/1812.11118) where they empirically show double descents in a variety of contexts, and give a theoretical tractable model where a similar phenomenon happens (linear random regression and random Fourier features). 

- From the experimental point of view, the reference seems to be the [Deep double descent paper](https://arxiv.org/pdf/1912.02292.pdf) by an OpenAI team - some figures therein were probably among the most expensive experimentns ever done in machine learning, both in \$\$\$ and in CO2. 

- A physicist approach on the double descent: [double trouble in double descent](https://arxiv.org/abs/2003.01054) and the [triple descent phenomenon](Triple descent : https://arxiv.org/pdf/2006.03509.pdf). 


- The random features model was rigorously studied in [Mei and Montanari's paper](https://arxiv.org/abs/1908.05355). 
