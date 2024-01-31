classdef Control_filter
    properties
        Sec_Matrix %--The coefficients of the secondary path (Ls x E_num).
        umW        %--The step size of the algorithm.
        Len        %--The length of the control filter.
        Ls         %--The length of the secondary path.
        Wc         %--The contorl filter. 
        Fd         %--The buffer of the control filter (Len x E_num).
        E_num      %--The number of the error microphones
        Xd         %--The delay line of the reference 
        Xf         %--The delay line of the filtered reference.
        Yd         %--The delay line of the control filter output.
    end
    methods 
        %-----------Function 1: initate the function-----------------------
        function obj=Control_filter(Sec_Matrix, Len, umW)
            obj.Len        = Len        ;
            obj.umW        = umW        ;
            csize          = size(Sec_Matrix);
            obj.Ls         = csize(1)   ;
            obj.E_num      = csize(2)   ;
            obj.Sec_Matrix = Sec_Matrix ;
            if isa(Sec_Matrix,'gpuArray')
                obj.Wc = gpuArray(zeros(Len,1));
                obj.Xd = gpuArray(zeros(Len,1));
                obj.Xf = gpuArray(zeros(obj.Ls,1));
                obj.Yd = gpuArray(zeros(obj.Ls,1));
                obj.Fd = gpuArray(zeros(Len,obj.E_num));
            else
                obj.Wc = zeros(Len,1);
                obj.Xd = zeros(Len,1);
                obj.Xf = zeros(obj.Ls,1);
                obj.Yd = zeros(obj.Ls,1);
                obj.Fd = zeros(Len,obj.E_num);
            end
        end
        %-----------Function 2: controller -------------------------------
        function [y_anti, obj] = Generator_antinoise(obj, xin, Er)
            umW1= obj.umW ;
            Xd1 = obj.Xd  ;
            Xf1 = obj.Xf  ;
            Wc1 = obj.Wc  ;
            Fd1 = obj.Fd  ;
            Yd1 = obj.Yd  ;
            Sec_Matrix1 = obj.Sec_Matrix;
            %---------------------------->>>----------------------<<<
            Xd1  = [xin;Xd1(1:end-1)];
            Xf1  = [xin;Xf1(1:end-1)];
            Wc1  = Wc1 - umW1 * Fd1 * Er;
            y_o  = Wc1'*Xd1 ; 
            Yd1  = [y_o;Yd1(1:end-1)];
            y_anti = Sec_Matrix1' * Yd1;
            fd  = Sec_Matrix1' * Xf1 ;
            Fd1  = [fd'; Fd1(1:end-1,:)];
            %---------------------------->>>----------------------<<<
            obj.Xd = Xd1;
            obj.Xf = Xf1;
            obj.Wc = Wc1;
            obj.Fd = Fd1;
            obj.Yd = Yd1;
        end
        %------------------------------------------------------------------
    end
end