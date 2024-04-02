primary_file = '/run/user/1000/gvfs/smb-share:server=psl-s-nasad,share=fedseq/UF_de_neurogenetique/Dossier LABORATOIRE/TECHNICIENS/Julie/SeqPilot/EPICHIR_v1/edsf_1000097015_20mm_primary_targets.bed'

ligne_l = []

with open(primary_file, 'r') as filin:
    lignes = filin.readlines()
    for ligne in lignes:
        ligne_l.append(ligne)


chr_l = []
starti_l = []
stopi_l = []
genes_l = []

for region in ligne_l :
    s = region.split('\t')
    
    #sans 'chr'
    #chr = s[0]
    #chr_l.append(chr[1:-1])

    #avec 'chr'
    chr_l.append(s[0])
    starti_l.append(s[1])
    #stopi = s[2]
    #stopi_l.append(stopi[:-1])
    stopi_l.append(s[2])
    genes_l.append(s[3])


startf_l = []
stopf_l = []


for i in range(len(stopi_l)) :
    d = starti_l[i]
    d = int(d)
    f = stopi_l[i]
    f = int(f)

    if d < f :
        startf_l.append(d)
        stopf_l.append(f)
    else :
        stopf_l.append(f)
        startf_l.append(d)


with open("/run/user/1000/gvfs/smb-share:server=psl-s-nasad,share=fedseq/UF_de_neurogenetique/Dossier LABORATOIRE/TECHNICIENS/Julie/SeqPilot/EPICHIR_v1/EPICHIR_v1_30_18012024.bed", "w") as filout:
    for i in range(len(stopf_l)) :
        filout.write(str(chr_l[i]) + '\t')
        filout.write(str(startf_l[i]-30) + '\t')
        filout.write(str(stopf_l[i]+30) + '\t')
        filout.write(str(genes_l[i]) + '\n')