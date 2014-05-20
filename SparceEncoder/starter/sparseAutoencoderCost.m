function [cost,grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, ...
                                             lambda, sparsityParam, beta, data)

% visibleSize: the number of input units (probably 64) 
% hiddenSize: the number of hidden units (probably 25) 
% lambda: weight decay parameter
% sparsityParam: The desired average activation for the hidden units (denoted in the lecture
%                           notes by the greek alphabet rho, which looks like a lower-case "p").
% beta: weight of sparsity penalty term
% data: Our 64x10000 matrix containing the training data.  So, data(:,i) is the i-th training example. 
  
% The input theta is a vector (because minFunc expects the parameters to be a vector). 
% We first convert theta to the (W1, W2, b1, b2) matrix/vector format, so that this 
% follows the notation convention of the lecture notes. 

W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
W2 = reshape(theta(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
b1 = theta(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
b2 = theta(2*hiddenSize*visibleSize+hiddenSize+1:end);

% Cost and gradient variables (your code needs to compute these values). 
% Here, we initialize them to zeros. 
cost = 0;
W1grad = zeros(size(W1)); 
W2grad = zeros(size(W2));
b1grad = zeros(size(b1)); 
b2grad = zeros(size(b2));

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost/optimization objective J_sparse(W,b) for the Sparse Autoencoder,
%                and the corresponding gradients W1grad, W2grad, b1grad, b2grad.
%
% W1grad, W2grad, b1grad and b2grad should be computed using backpropagation.
% Note that W1grad has the same dimensions as W1, b1grad has the same dimensions
% as b1, etc.  Your code should set W1grad to be the partial derivative of J_sparse(W,b) with
% respect to W1.  I.e., W1grad(i,j) should be the partial derivative of J_sparse(W,b) 
% with respect to the input parameter W1(i,j).  Thus, W1grad should be equal to the term 
% [(1/m) \Delta W^{(1)} + \lambda W^{(1)}] in the last block of pseudo-code in Section 2.2 
% of the lecture notes (and similarly for W2grad, b1grad, b2grad).
% 
% Stated differently, if we were using batch gradient descent to optimize the parameters,
% the gradient descent update to W1 would be W1 := W1 - alpha * W1grad, and similarly for W2, b1, b2. 
% 

% [nFeatures, nSamples] = size(data);
% % first calculate the regular cost function J
%  
% [a1, a2, a3] = getActivation(W1, W2, b1, b2, data);
% errtp = ((a3 - data) .^ 2) ./ 2;
% err = sum(sum(errtp)) ./ nSamples;
% % now calculate pj which is the average activation of hidden units
% pj = sum(a2, 2) ./ nSamples;
% % the second part is weight decay part
% err2 = sum(sum(W1 .^ 2)) + sum(sum(W2 .^ 2));
% err2 = err2 * lambda / 2;
% % the third part of overall cost function is the sparsity part
% err3 = zeros(hiddenSize, 1);
% err3 = err3 + sparsityParam .* log(sparsityParam ./ pj) + (1 - sparsityParam) .* log((1 - sparsityParam) ./ (1 - pj));
% tcost = err + err2 + beta * sum(err3);
%  
% % following are for calculating the grad of weights.
% delta3 = -(data - a3) .* dsigmoid(a3);
% delta2 = bsxfun(@plus, (W2' * delta3), beta .* (-sparsityParam ./ pj + (1 - sparsityParam) ./ (1 - pj))); 
% % delta2 = (W2' * delta3);
% delta2 = delta2 .* dsigmoid(a2);
% nablaW1 = delta2 * a1';
% nablab1 = delta2;
% nablaW2 = delta3 * a2';
% nablab2 = delta3;
%  
% tW1grad = nablaW1 ./ nSamples + lambda .* W1;
% tW2grad = nablaW2 ./ nSamples + lambda .* W2;
% tb1grad = sum(nablab1, 2) ./ nSamples;
% tb2grad = sum(nablab2, 2) ./ nSamples;

%---------------- My implementation ---------------
[err, pj] = CalCost_all(W1, W2, b1, b2, data);
err2 = lambda/2*(sum(W1(:).^2) + sum(W2(:).^2));
err3 = beta*sum(KL(sparsityParam, pj(:)));
cost = err+err2 + err3;

[W1grad, W2grad, b1grad, b2grad] = CalGradient(W1, W2, b1, b2, data, lambda,beta, sparsityParam, pj);

%-------------------------------------------------------------------
% After computing the cost and gradient, we will convert the gradients back
% to a vector format (suitable for minFunc).  Specifically, we will unroll
% your gradient matrices into a vector.

grad = [W1grad(:) ; W2grad(:) ; b1grad(:) ; b2grad(:)];

end

%-------------------------------------------------------------------
% Here's an implementation of the sigmoid function, which you may find useful
% in your computation of the costs and the gradients.  This inputs a (row or
% column) vector (say (z1, z2, z3)) and returns (f(z1), f(z2), f(z3)). 

function sigm = sigmoid(x)
  
    sigm = 1 ./ (1 + exp(-x));
end

%-------------------------------------------------------------------
% This function calculate dSigmoid
%
% function dsigm = dsigmoid(a)
% dsigm = a .* (1.0 - a);
%  
% end
 
%-------------------------------------------------------------------
% This function return the activation of each layer
%
function [ainput, ahidden, aoutput] = getActivation(W1, W2, b1, b2, input)
 
ainput = input;
ahidden = bsxfun(@plus, W1 * ainput, b1);
ahidden = sigmoid(ahidden);
aoutput = bsxfun(@plus, W2 * ahidden, b2);
aoutput = sigmoid(aoutput);
end

function [layer_h layer_output] = CalLayerValue(W1, W2, b1, b2, input)
    layer_h = sigmoid(W1*input + b1);
    layer_output = sigmoid(W2*layer_h + b2);
end

function cost = CalCost_single(input, output)
    cost = sum((input(:)-output(:)).^2)/2;
end

function [cost pj] = CalCost_all(W1, W2, b1, b2, data)
    cost = 0;
    pj =0;
    for n=1:size(data,2)
        [layer_hidden, layer_output] = CalLayerValue(W1, W2, b1, b2, data(:,n));
        cost = cost + CalCost_single(data(:,n), layer_output);
        pj = pj + layer_hidden(:);
    end
    cost = cost/size(data,2);
    pj = pj/size(data,2);
end

function result = KL(p, pj)
    result = p.*log(p./pj)+(1-p).*log((1-p)./(1-pj));
end

function result = dsigmoid(fx)
    result = fx.*(1-fx);
end

function [gW1, gW2, gb1, gb2] = CalGradient(W1, W2, b1, b2, input, lambda,beta, sparsityParam, pj)
    gW1 = zeros(size(W1));
    gW2 = zeros(size(W2));
    gb1 = zeros(size(b1));
    gb2 = zeros(size(b2));
    samplenum = size(input,2);
    
    for m=1:samplenum
        [tgW1 tgW2 tgb1 tgb2] = CalD(W1, W2, b1, b2, input(:,m),beta, sparsityParam, pj);
        gW1 = gW1 + tgW1;
        gW2 = gW2 + tgW2;
        gb1 = gb1 + tgb1;
        gb2 = gb2 + tgb2;
    end
    gW1 = gW1/samplenum + lambda.*W1;
    gW2 = gW2/samplenum + lambda.*W2;
    gb1 = gb1/samplenum;
    gb2 = gb2/samplenum;
end

function [gW1 gW2 gb1 gb2] = CalD(W1, W2, b1, b2, input,beta, sparsityParam, pj)
    [layer2 layer3] = CalLayerValue(W1, W2, b1, b2, input);
    delta3 = -(input - layer3).*dsigmoid(layer3);
    delta2 = (W2' * delta3).*dsigmoid(layer2) + beta*(-sparsityParam./pj+(1-sparsityParam)./(1-pj)).*dsigmoid(layer2);
    gW1 = delta2*input';
    gW2 = delta3*layer2';
    gb1 = delta2;
    gb2 = delta3;
end