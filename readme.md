
Riemannian covariance descriptors(RieCovDs) via covariance computation on the manifold of Gaussians for image set coding. 
Written by Kai-Xuan Chen (e-mail: kaixuan_chen_jsh@163.com)  


The ETH-80 dataset is needed to be downloaded(https://github.com/Kai-Xuan/ETH-80/),  
and put 8 filefolders(visual image sets from 8 different categories) into filefolder '.\ETH-80\'.  
Please run 'read_ETH.m' to generate RieCovDs. Then run 'run_ETH_NNMethods.m' and 'run_ETH_DisMethods.m' for image set classification.  


If you find this repository useful for your research, Please cite the following paper:  
BibTex :  
```
@article{chen2020covariance,
  title={Covariance Descriptors on a Gaussian Manifold and their Application to Image Set Classification},
  author={Chen, Kai-Xuan and Ren, Jie-Yi and Wu, Xiao-Jun and Kittler, Josef},
  journal={Pattern Recognition},
  pages={107463},
  year={2020},
  publisher={Elsevier}
}
```


For more experiment, you can test on Virus dataset (https://github.com/Kai-Xuan/Virus/) 

For more technical details.
1. Distances on the SPD manifold: https://github.com/Kai-Xuan/SPD-OPERATIONS/tree/master/SPD-Metrics/
2. Means on the SPD manifold: https://github.com/Kai-Xuan/SPD-OPERATIONS/tree/master/SPD-Means/
3. Local Difference Vectors on the SPD manifold: https://github.com/Kai-Xuan/SPD-OPERATIONS/tree/master/SPD-LDV/


