#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Ped = F H P M I (Femme Homme Pere Mere IndexSexeIndetermine)

import sys, os, subprocess, pprint, glob

print("\ncram.py start.\n")

pp = pprint.PrettyPrinter(indent=4)

ref = "/media/Data1/jbogoin/ref/hg19_ref/hg19_std.fa.gz"

run = sys.argv[1].replace("SeqCap_EZ_MedExome","SeqCap-EZ-MedExome")

techno = run.split("_")[0]

date = run.split("_")[1]

if len(sys.argv[1].split('_')) > 4:
    date = date + "-" + str(run.split('_')[-1])

ped_d = {}
count = 0

with open("pedigree.txt", 'r') as ped:
    
    for line in ped:
        fam, index, index_sex, index_ped, mom, mom_ped, dad, dad_ped = "", "", "", "", "", "", "", ""
        line = line.rstrip()

        if not line.startswith("Fam"):

            fam = line.split("\t")[0]
            index = line.split("\t")[1]
            mom = line.split("\t")[2]
            dad = line.split("\t")[3]
            index_sex = line.split("\t")[4]
            trio = index + '-' + mom + '-' + dad

            if '_' in fam:
                fam = fam.replace('/','-')
                fam = fam.replace('_','-')
            
            if fam == "0":
                count += 1
                fam = "NA" + str(count)
            
            if index_sex == "M":
                index_ped = "H"
            elif index_sex == "F":
                index_ped = "F"
            else:
                index_ped = "I"

            ped_d[index] = {}
            ped_d[index]['ped'] = index_ped
            ped_d[index]['fam'] = fam
            ped_d[index]['trio'] = trio
            
            mom_ped = "M"
            ped_d[mom] = {}
            ped_d[mom]['ped'] = mom_ped
            ped_d[mom]['fam'] = fam
            ped_d[mom]['trio'] = trio
            
            dad_ped = "P"
            ped_d[dad] = {}
            ped_d[dad]['ped'] = dad_ped
            ped_d[dad]['fam'] = fam
            ped_d[dad]['trio'] = trio
                       
#pp.pprint(ped_d)

for f in glob.glob('./BAM/*.bam'):

    file = f.split('/')[2]
    sample = file.split('.')[0]
    extension = ".cram"
    
    if ped_d[sample]['fam'].startswith('NA'):
        ped_d[sample]['fam'] = 'NA'
    
    items = [sample, ped_d[sample]['ped'], techno, date, \
        ped_d[sample]['fam'], ped_d[sample]['trio']]

    new_name = str('_'.join(items)) + extension

    subprocess.call("samtools view -@ 12 -C -T " + ref + " -o " + new_name + " " + f, shell = "/bin/bash")
    subprocess.call("samtools index " + new_name, shell = "/bin/bash")

subprocess.call("mkdir CRAM", shell = "/bin/bash")
subprocess.call("mv *.cram CRAM", shell = "/bin/bash")
subprocess.call("mv *.cram.crai CRAM", shell = "/bin/bash")


print("\ncram.py job done!\n")