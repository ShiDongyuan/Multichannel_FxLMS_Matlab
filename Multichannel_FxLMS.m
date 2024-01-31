% .___  ___.   ______         __________   ___  __      .___  ___.      _______.
% |   \/   |  /      |       |   ____\  \ /  / |  |     |   \/   |     /       |
% |  \  /  | |  ,----' ______|  |__   \  V  /  |  |     |  \  /  |    |   (----`
% |  |\/|  | |  |     |______|   __|   >   <   |  |     |  |\/|  |     \   \
% |  |  |  | |  `----.       |  |     /  .  \  |  `----.|  |  |  | .----)   |
% |__|  |__|  \______|       |__|    /__/ \__\ |_______||__|  |__| |_______/

classdef Multichannel_FxLMS
    properties
        controller % The control filter matrix: Wc--[Filter length x Control unit x Reference microphone]
%        Sec_path  % Sec_path [Filter length x Error num x Speaker num]
        Cunit
        R_num
        E_num
        S_num
        lenc
    end
    methods
        %-------------------Initated---------------------------------------
        function obj = Multichannel_FxLMS(Wc,Sec_estimate,umW)
            % The secondary path matrix: Sec--- [Filter length x Error num x Speaker num]
            w_size = size(Wc);
            len   = w_size(1);
            Cunit = w_size(2);
            if length(w_size)== 2
                R_num = 1        ;
            else
                R_num = w_size(3);
            end
            obj.lenc  = len  ;
            obj.Cunit = Cunit;
            obj.R_num = R_num;
            
            s_size = size(Sec_estimate);
            E_num  = s_size(2);
            if length(s_size)==2
                S_num  = 1        ;
            else
                S_num  = s_size(3);
            end
            obj.E_num = E_num ;
            obj.S_num = S_num ;
            %%
            %disx = repmat('',5,1);
            %%
            obj.controller = repmat(Control_filter(squeeze(Sec_estimate(:,:,1)),len, umW),Cunit,R_num);
            if Cunit ~= 1  % Full structure
                for jj = 1:R_num 
                    for kk = 1:Cunit
                        obj.controller(kk,jj) = Control_filter(squeeze(Sec_estimate(:,:,kk)),len, umW);                   
                    end
                end
                disx3 = sprintf('Structure: Fully-connection feedforward ANC.');
            else         % Collocated structure
                for jj = 1:R_num
                    obj.controller(1,jj) = Control_filter(squeeze(Sec_estimate(:,:,jj)) ,len, umW);
                end
                disx3 = sprintf('Structure: Collocated feedforward ANC.');
            end 
            fprintf('<<--------------------------------------------------->>\n');
            fprintf('The multichannel FxLMS has been sucessfuly created.\n');
            disp(disx3);
            if isa(Wc,'gpuArray')
                fprintf('Hardware usage: GPU.\n');
            else
                fprintf('Hardware usage: CPU.\n');
            end
            fprintf('Dimension: %d x %d x %d \n', R_num, S_num, E_num);
            fprintf('<<--------------------------------------------------->>\n');
        end
        %-------------------ANC controller---------------------------------
        function [Er, obj] = FxLMS_cannceller(obj, Re, Disturbance)
            % Re: the reference matrix [microphone x signal length]
            % Disturabnce: the disturbance matrix [microphon x singal length]
            data_size = size(Re)    ;
            len       = data_size(2);
            if isa(Re,'gpuArray')
                E = gpuArray(zeros(obj.E_num,len+1));
            else
                E = zeros(obj.E_num,len+1);
            end
            %% Filtering processing
            tic
            fprintf('<<-------------------START-----------------------------\n');
            %%
            for nn = 1: len
                if obj.Cunit ~=1
                    for jj = 1:obj.R_num
                        for kk = 1:obj.Cunit
                            [Y,obj.controller(kk,jj)] = Generator_antinoise(obj.controller(kk,jj),Re(jj,nn),E(:,nn));
                            E(:,nn+1) = E(:,nn+1) + Y ; 
                        end
                    end
                else
                    for jj = 1:obj.R_num
                        [Y,obj.controller(1,jj)] = Generator_antinoise(obj.controller(1,jj),Re(jj,nn),E(:,nn));
                         E(:,nn+1) = E(:,nn+1) + Y ; 
                    end
                end
                E(:,nn+1) = Disturbance(:,nn) + E(:,nn+1);
            end
            Er = gather(E(:,2:end));
            %%
            toc
            fprintf('---------------------END----------------------------->>\n');
            %
        end
        %---------------Function 3: Extra coefficients---------------------
        function Wc = Get_coefficients(obj)
            if obj.Cunit ~=1
                Wc = zeros(obj.lenc,obj.Cunit,obj.R_num);
                    for jj = 1:obj.R_num
                        for kk = 1:obj.Cunit
                            contorler = obj.controller(kk,jj);
                            Wc(:,kk,jj)=contorler.Wc;
                        end
                    end
            else
                Wc = zeros(obj.lenc,obj.R_num);
                    for jj = 1:obj.R_num
                        contorler = obj.controller(1,jj);
                        Wc(:,jj)=contorler.Wc;
                   end
           end
        end
    end
end