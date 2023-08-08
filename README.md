# Light-field-fiber-bundle-imaging

# General information
 1. The algorithm was developed in MATLAB environment.
 2. The algorithm was developed based on reference: Optical fiber bundles: Ultra-slim light field imaging probes by A. Orth, etc. Please also cite this paper if you use this code for your project.
 3. example sample dataset is provided in folders: single_layer, the files' name indicate the distance from sample to fiber bundle surface.
 4. The function files are put in folder: files.

# How to use
There are 5 major files for this algorithm, and each file stands for a different intermediate step. Please run these files in sequence

1. Digital_filter_aperture.m: Digital aperture filtering. For different datasets, make sure to choose the correct path for their reference images. The detected cores could have centriod-off from the measured image. Manually adjust parameters: adjust_x, adjust_y, until the cores of two images matched. A dataset file: full&small including two apertured images will be saved for later uses.
2. raw_refocusing.m: Light-field refocusing by shift-and-add technique. Two files: lightfield.tif and focal_stacks.tif are generated showing the perspective shift animation and refocused light field stacks. The tif files can be played in Fiji ImageJ.
3. Simulated_psf.m: Preparing simulated PSFs for deconvolution.
4. deconvolution.m: Deconvolution for light-field focal stacks. A window size ws = 17 × 17 was set here. For imaging objects with greater axial distances > 80 um, larger ws would be needed, but it would also largely increase the computational time.
5. Image_reconstruct.m: xz-MIP is ploted and Con_final Image.tif is generated showingthe deconvolved focal stacks of the target volume. The tif files can be played by Fiji ImageJ

Note: We run the algorithm on an Intel(R) Xeon(R) Gold 6258R CPU, 768GB RAM. The digital aperture filtering may take up to 4 minutes, the digital refoucsing and psf simulattion take up to 2 minutes, and the deconvolution may require greater than 15 minutes (largely depends on the volume and complexity of the images)

Contact
Created by Peisheng Ding (peisheng.ding@mpi-halle.mpg.de, peisheng.ding@mail.utoronto.ca)
