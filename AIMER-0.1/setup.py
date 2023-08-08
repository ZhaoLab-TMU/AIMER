from setuptools import setup

setup(name='AIMER',
    version='0.1',
    description='AIMER is a package to identify allele-specific methylated regions (AMR) from bisulfite sequencing data (WGBS)',
    author='ZhaoLab-TMU',
    author_email='luoyanrui@hotmail.com',
    license='MIT',
    packages=['AIMER'],
    scripts=['bin/AIMER'],
    package_data={'AIMER': ['get_bin.so','get_amr.so','bin_extension.so']},
    zip_safe=False,
    url="https://github.com/ZhaoLab-TMU/AIMER",
    python_requires='>=3.7',
    install_requires=['numpy>=1.22.3','pyfasta>=0.5.2','gtfparse>=1.2.1','pandas>=1.4.2','pybedtools>=0.9.0','pyranges>=0.0.115','gtfparse>=1.2.1'],
    include_package_data=False)
setup