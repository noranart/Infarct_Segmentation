for i=1:23
    for x=1:224
        for y=1:224
            if (D(x,y,i)==0
                backgroundLabel(:,:,i) = 1;
            else
                backgroundLabel(:,:,i) = 0;
            end
        end
    end
end
