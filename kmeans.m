%created by Ziyang Zhao @2014/07/26
%kmeans(x, k, initg)
%first matlab function ever(why my first one is not helloworld)
function [ ] = kmeans( x, k, initg)
    [numOfPoints, dummy] = size(x);%number of points
    
    tempCluster = zeros(k, 2);
    centreOfCluster = zeros(k, 2);%store of the centre of the k clusters
    numOfPOfCluster = zeros(k, 1);%store the number of points in every cluster
    
    if nargin < 3%if the initg is ignored
        cluster = randi(k, [numOfPoints, 1]);%a random initial clustering is assumed
    else
        cluster = zeros(numOfPoints, 1);
    end
    
    %compute the centre of the k clusters.
    for i = 1:numOfPoints
        tempCluster(cluster(i), 1) = tempCluster(cluster(i), 1) + x(i, 1);
        tempCluster(cluster(i),2) = tempCluster(cluster(i), 2) + x(i, 2);
        numOfPOfCluster(cluster(i)) = numOfPOfCluster(cluster(i)) + 1;
    end

    for i = 1:k
        centreOfCluster(i, 1) = tempCluster(i, 1) / numOfPOfCluster(i);
        centreOfCluster(i, 2) = tempCluster(i, 2) / numOfPOfCluster(i);
    end 
    
    
    numOfMovement = 1000;
    while numOfMovement > 0%if the number the Movement is 0, means we have assigned all the points to the closest centre.
        numOfMovement = 0;
        
        %each point is reassigned to a group whose center is closest to the
        %point, and the recomputed the centres
        for i = 1:numOfPoints
            clusterMark = 0; 
            smallestDis = 100000000;
            %find the closest centre
            for j = 1:k
                disCurr = (x(i, 1) - centreOfCluster(j, 1))^2 + (x(i, 2) - centreOfCluster(j, 2))^2; 
                if smallestDis > disCurr
                    smallestDis = disCurr;
                    clusterMark = j;
                end
            end
            
            %if there exist an centre that is closer
            if cluster(i) ~= clusterMark
                %delete the point from the old cluster
                tempCluster(cluster(i), 1) = tempCluster(cluster(i), 1) - x(i, 1);
                tempCluster(cluster(i), 2) = tempCluster(cluster(i), 2) - x(i, 2);
                numOfPOfCluster(cluster(i)) = numOfPOfCluster(cluster(i)) - 1;
                %recompute the centre
                centreOfCluster(cluster(i), 1) = tempCluster(cluster(i), 1) / numOfPOfCluster(cluster(i));
                centreOfCluster(cluster(i), 2) = tempCluster(cluster(i), 2) / numOfPOfCluster(cluster(i));
                
                %add the point to the new cluster
                tempCluster(clusterMark, 1) = tempCluster(clusterMark, 1) + x(i, 1);
                tempCluster(clusterMark, 2) = tempCluster(clusterMark, 2) + x(i, 2);
                numOfPOfCluster(clusterMark) = numOfPOfCluster(clusterMark) + 1;
                %recompute the centre
                centreOfCluster(clusterMark, 1) = tempCluster(clusterMark, 1) / numOfPOfCluster(clusterMark);
                centreOfCluster(clusterMark, 2) = tempCluster(clusterMark, 2) / numOfPOfCluster(clusterMark);
                cluster(i) = clusterMark;
                
                numOfMovement = numOfMovement + 1;
            end
            
        end
    end
    
    %display the result
    hold on
    for i = 1:k
        xCoor = [];
        yCoor = [];
        for j = 1:numOfPoints
            if cluster(j) == i
                xCoor = [xCoor, x(j, 1)];
                yCoor = [yCoor, x(j, 2)];
            end
        end
        scatter(xCoor, yCoor);
        clear xCoor
        clear yCoor
    end
    hold off
end
