%created by Ziyang Zhao @2014/07/29
%fds(smf_file, varargin)
function [] = fds(smf_file, varargin)

    %read the mesh, 
    %F is the matrix of faces and X is the matrix of vertices
    [F, X] = read_smf(smf_file);
    
    %draw the original mesh
    figure(1);
    trimesh(F, X(:,1), X(:,2), X(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');
    
    %get the number of vertices and faces
    [numOfFace, temp0] = size(F);
    [numOfVertex, temp1] = size(X);
    
    %compute the Laplacian operator K
    K = zeros(numOfVertex, numOfVertex);  
    for i = 1:numOfFace
        for j = 1:temp0
            K(F(i, j), F(i, j)) = K(F(i, j), F(i, j)) + 1;
            for k = 1: temp0
                if k~= j
                    K(F(i, j), F(i, k)) = -1;
                end
            end
        end
    end
    
    %compute Q1, which is the eigenvectors of K
    [Q1, D] = eig(K);
    
    %compute Q2, which is the transpose of Q1
    Q2 = transpose(Q1);
    
    %compute X2, which is the fourier transform of the mesh signal
    X2 = Q2 * X;
    
    %get the size of vector
    [dummy, argc] = size(varargin{1});
    
    for i = 1:argc %for each number in the vector        
        %X3 is the new mesh after spectral compression
        X3 = zeros(numOfVertex, 3);        
        %truncate the linear sum
        for j = 1: varargin{1}(i)
            X3 = X3 + Q1(:,j)*X2(j,:);
        end
        
        %draw the new mesh
        hold on
        figure(i+1);
        trimesh(F, X3(:,1), X3(:,2), X3(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong')
        clear X3
    end
    hold off
end

