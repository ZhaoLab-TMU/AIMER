1. Cell type signature gene sets for human downloaded from https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2023.2.Hs/c8.all.v2023.2.Hs.symbols.gmt, The ./AIMER/resources/human/human_gmt_convert.r script is used to convert the gmt format file to the --annotation input file in the AIMER get_amr step, the annotation file includes the Tissue and Gene columns. If Gene column contains multiple genes, separate them with comma. The tissues included in this file are as follows: Adrenal, Bone Marrow, Cerebellum, Cerebrum, Cord Blood, Ctx, Duodenal, Esophageal, Esophagus, Eye, Gastric, Heart, Intestine, Kidney, Liver, Lung, Midbrain Neurotypes, Muscle, Olfactory Neuroepithelium, Ovary, Pancreas, Pfc, Placenta, Spleen, Thymus.

2. Cell type signature gene sets for mouse downloaded from https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2023.2.Mm/m8.all.v2023.2.Mm.symbols.gmt, The ./AIMER/resources/mouse/mouse_gmt_convert.r script is used to convert the gmt format file to the --annotation input file m8.all.v2023.2.Mm.symbols.gmt.xls in the AIMER get_amr step, the annotation file includes the Tissue and Gene columns. If Gene column contains multiple genes, separate them with comma. The tissues included in this file are as follows: Aorta, Bladder, Brain, Brown Adipose, Diaphragm, Gonadal Adipose, Heart, Heart And Aorta, Kidney, Large Intestine, Limb Muscle, Liver, Lung, Mammary Gland, Marrow, Mesenteric Adipose, Organogenesis, Pancreas, Skin, Spleen, Subcutaneous Adipose, Thymus, Tongue, Trachea, Trachea Smooth Muscle, Uterus.