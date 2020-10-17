function [R, S] = poleplace(B, A, Hr, Hs, P)
%Poleplace [R, S] = poleplace(B, A, Hr, Hs, P)
%   Compute the RS controller though sylvester matrix. The function must
%   have five inputs and two outputs.
%   Inputs:
%          - B, A : vectors
%          - Hr, Hs : vectors
%          - P : vector of the desired pole placement ([1 p1 p2 ... pN])
%   Outputs:
%          - R, S : vectors


assert(nargin==5);
    
   
    A_prime = conv(A, Hs)';
    B_prime = conv(B, Hr)';
    
    
    nB = length(conv(B, Hr))-1;
    nA = length(conv(A, Hs))-1;
    nP = length (P)-1;
    nS = nB - 1;
    % turn off TOEPLITZ warning
    WS = warning('off','MATLAB:toeplitz:DiagonalConflict') ;

    
    MA = toeplitz([A_prime(:); zeros(nB-1,1)],zeros(nB,1));
    MB = toeplitz([B_prime(:); zeros(nA-1,1)],zeros(nA,1));
    
    M = [MA MB];
    
    p = [P'; zeros(nA+nB-nP-1,1)];
    
    x = M\p;
    
    S = x(1:nS+1);
    S = conv(S, Hs);
    R = x(nS+2:end);
    R = conv(R, Hr);
    warning(WS.state,WS.identifier)
end

