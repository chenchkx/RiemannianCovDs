Riemannian covariance descriptors(RieCovDs) for describing image sets.  
 

Written by Kai-Xuan Chen (e-mail: kaixuan_chen_jsh@163.com)  
version 2.0 -- December/2018  
version 1.0 -- August/2018  


The ETH-80 dataset is needed to be downloaded(https://github.com/Kai-Xuan/ETH-80/),  
and put 8 filefolders(visual image sets from 8 different categories) into filefolder '.\ETH-80\'.  
Please run 'read_ETH.m' to generate CSPD matrices. Then run 'run_ETH_NNMethods.m' and 'run_ETH_DisMethods.m' for image set classification.  


For Riemannian local difference vector on SPD manifold and Riemannian means on SPD manifold. please refer to:

Masoud Faraki, Mehrtash T Harandi, and Fatih Porikli. More about vlad: A leap from euclidean to riemannian manifolds.
In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition, pages 4951–4960, 2015. (https://github.com/mfaraki/Riemannian_VLAD)


For classification, we employ four NN classifiers and four discriminative classifiers in this source code(Version 2.0).  

Ker-SVM : Qilong Wang implemented a one-vs-all classifier by using LIBSVM package in the paper:  
Q. Wang, P. Li, W. Zuo, and L. Zhang. Raid-g: Robust estimation of approximate infinite dimensional gaussian with application to material recognition. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition, pages 4433-4441, 2016.  
Chih-Chung Chang and Chih-Jen Lin. Libsvm: a library for support vector machines. ACM transactions on intelligent systems and technology
(TIST), 2(3):27, 2011.

LogEKSR : This method was proposed in the paper:  
P. Li, Q. Wang, W. Zuo, and L. Zhang. Log-euclidean kernels for sparse representation and dictionary learning. In Proceedings of the IEEE International Conference on Computer Vision, pages 1601-1608, 2013.

COV-LDA/COV-PLS :  This method was proposed in the paper:  
R. Wang, H. Guo, L. S. Davis, and Q. Dai. Covariance discriminative learning: A natural and efficient approach to image set classification. In Computer Vision and Pattern Recognition (CVPR), 2012 IEEE Conference on, pages 2496-2503. IEEE, 2012.  
