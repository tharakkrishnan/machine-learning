function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
n = size(X, 2);         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% y is of size 5000 x 1
% Y is of size 5000 x 10
Y = zeros(size(y(:,1)), max(y));
for i = 1:size(y(:,1))
    Y(i,y(i))=1;
end

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Add the bias elements in input need to be added

Xb = resize(X,m,n+1);
Xb = circshift(Xb,[0,1]);
Xb(:,1) = 1;

for t=1:m
    a1 = Xb(t,:);
    
    % Hidden Layer 1
    a2=sigmoid(a1 * Theta1'); 
    a2 = resize(a2,size(a2, 1),size(a2, 2)+1);
    a2 = circshift(a2,[0,1]);
    a2(:,1) = 1;
    
    % Output Layer
    a3 = sigmoid(a2* Theta2');
    h  = a3;

    %Compute cost J
    j = (-1) * Y(t,:) .* log(h) - (1 - Y(t,:)) .* log(1 - h);
    jk = j * ones(num_labels,1);

    J +=jk;
end

J = J/m;

%Compute regularization factor
r = (sum(sum(Theta1(:,2:size(Theta1,2)) .* Theta1(:,2:size(Theta1,2))))  + sum(sum(Theta2(:,2:size(Theta2,2)) .* Theta2(:,2:size(Theta2,2)))))*lambda/(2*m);
J = J+r;

%============================================================
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
for t=1:m
    a1 = Xb(t,:);
    %1. Feedforward part 
    % Hidden Layer 1
    a2=sigmoid(a1 * Theta1'); 
    a2 = resize(a2,size(a2, 1),size(a2, 2)+1);
    a2 = circshift(a2,[0,1]);
    a2(:,1) = 1;
    
    % Output Layer
    a3 = sigmoid(a2* Theta2');
    h  = a3;
    %2. Error calculation 
    d3 = a3-Y(t,:);
    d2 = (d3*Theta2) .* a2.*(1-a2);
 
    Theta1_grad += (a1'*d2(2:end))';  
    Theta2_grad += (a2'*d3)';     
end

Theta1_grad /=m;  
Theta2_grad /=m;

% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Theta1_grad(:,2:end) += Theta1(:,2:end)*lambda/m;
Theta2_grad(:,2:end) += Theta2(:,2:end)*lambda/m;


















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
