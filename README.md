#Infarct Segmentation
An  infarct segmentation software based on DWI (Diffusion-Weighted Magnetic Resonance Imaging).

![](/git_pic/screenshot.gif)

#How to use
- run Infarct Segmentation.exe
- load DWI (dicom format)
- select fast for Otsu Method
- select Accurate for Fuzzy C-means Clustering
- (optional) select 2 points to define region of interest
- hit begin to start segmentation
- hit save to export result as jpg

#Research
We tested several popular techniques including Otsu Method, Fuzzy C-means Clustering, Hill-Climbing based Segmentation, and Growcut. DWI test cases were extracted from 13 patients. We verified the result on Fluid-attenuated inversion recovery MRI (FLAIR MRI). For more information [(click here)](/paper.pdf).

#File Structure
- bin [binary software created by MATLAB]
- layout [gui image]
- source
  - matlab_gui [bin source code]
  - matlab_research [research source code]
  - gui.au3 [gui source code]
- Infarct Segmentation.exe [main]
- license agreement
- paper.pdf