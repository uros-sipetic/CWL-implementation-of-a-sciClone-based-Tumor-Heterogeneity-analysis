{
  "class": "Workflow",
  "steps": [
    {
      "id": "#VCFtools_Merge",
      "run": {
        "outputs": [
          {
            "label": "Output file merged vcfs",
            "sbg:fileTypes": "VCF, VCF.GZ",
            "type": [
              "null",
              "File"
            ],
            "description": "Merged vcf files from the input.",
            "id": "#output_file",
            "outputBinding": {
              "glob": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  arr = [].concat($job.inputs.input_files);\n  \n  function common_end(strs) {\n  \n  \t// Find minimum length of file name\n  \n  \tls = [];\n    whole = [];\n\tfor (i=0;i<strs.length;i++){\n  \t\tls = ls.concat(strs[i].path.split('/').pop().length);\n        whole = whole.concat(strs[i].path.length);\n  \t}\n \tl = Math.min.apply(Math,ls);\n  \n  \t// Loop from the end through characters and check if they are the same for all\n  \n \tind = 0;\n \tflag = 0;\n \tfor (i=1;i<=l;i++){\n    \tfor (j=1;j<strs.length;j++){\n      \t\tif (strs[0].path[whole[0]-i]!=strs[j].path[whole[j]-i]){\n        \tflag = 1;\n        \tbreak\n      \t\t}\n   \t\t}\n   \t \tif (flag == 1){\n   \t \t  \tbreak\n   \t    } else {\n      \t\tind = ind + 1;\n        }\n  \t }\n  \n  // Assign and return longest ending common substring\n  if (ind>0) {\n  \tcomstr = strs[0].path.slice(-ind);\n  } else {\n    comstr = 'different_extensions'\n  }\n  \n  return comstr\n  \n  }\n  \n  \n  if(arr.length==1) { \n    new_filename = arr[0].path.split('/').pop()    \n  } else {\n\n    if (arr[0].metadata){  \n \t \t  if (arr[0].metadata[\"sample_id\"]){        \n  \t\t\t prefix = arr[0].metadata[\"sample_id\"];   \n   \t\t  } else {\n   \t\t\t prefix = 'sample_unknown';\n \t      }\n    } else {\n      \n     prefix = 'sample_unknown';\n      \n    }\n\n  \n  // Create joint name and add the merged suffix\n  \n  joint_name = prefix + '_' + common_end(arr);\n  new_filename = joint_name.split('.').slice(0,-1).join('.') + '.merged.vcf'\n  \n  }\n  \n  if ($job.inputs.compressed){\n    new_filename += '.gz'\n  }\n  \n  return new_filename\n\n}"
              },
              "sbg:inheritMetadataFrom": "#input_files",
              "secondaryFiles": [
                ".tbi"
              ]
            }
          }
        ],
        "sbg:toolkitVersion": "0.1.14",
        "inputs": [
          {
            "label": "vcf header file",
            "sbg:fileTypes": "VCF",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "Use the provided VCF header.",
            "id": "#vcf_header",
            "inputBinding": {
              "position": 3,
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  arr = [].concat($job.inputs.input_files);\n \n  if (arr.length == 1 || !$job.inputs.vcf_header) {\n    \n    return ''\n    \n  } else {\n\n   \treturn '-H ' + $job.inputs.vcf_header.path\n\n  }\n}"
              },
              "secondaryFiles": [],
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Trim",
            "sbg:toolDefaultValue": "FALSE",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "If set, redundant ALTs will be removed.",
            "id": "#trim",
            "inputBinding": {
              "position": 7,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  arr = [].concat($job.inputs.input_files);\n \n  if (arr.length == 1) {\n    \n    return ''\n    \n  } else {\n    \n    if ($job.inputs.trim) {\n      \n   \t\treturn '-t'\n    \n    }\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Silent",
            "sbg:toolDefaultValue": "FALSE",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "Try to be a bit more silent, no warnings about duplicate lines.",
            "id": "#silent",
            "inputBinding": {
              "position": 6,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  arr = [].concat($job.inputs.input_files);\n \n  if (arr.length == 1) {\n    \n    return ''\n    \n  } else {\n    \n    if ($job.inputs.silent) {\n      \n   \t\treturn '-s'\n    \n    }\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Remove duplicates",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "If there should be two consecutive rows with the same chr:pos, print only the first one.",
            "id": "#remove_duplicates",
            "inputBinding": {
              "position": 1,
              "separate": true,
              "prefix": "-d",
              "sbg:cmdInclude": true
            }
          },
          {
            "label": "Regions",
            "sbg:fileTypes": "TXT",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "Do only the given regions (comma-separated list or one region per line in a file).",
            "id": "#regions",
            "inputBinding": {
              "position": 4,
              "prefix": "-r",
              "secondaryFiles": [],
              "streamable": false,
              "separate": true,
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Ref for missing",
            "description": "Use the REF allele instead of the default missing genotype. Because it is not obvious what ploidy should be used, a user-defined string is used instead (e.g. 0/0).",
            "sbg:toolDefaultValue": "0/0",
            "type": [
              "null",
              "string"
            ],
            "required": false,
            "sbg:altPrefix": "-R",
            "id": "#ref_for_missing",
            "inputBinding": {
              "position": 8,
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  arr = [].concat($job.inputs.input_files);\n \n  if (arr.length == 1) {\n    \n    return ''\n    \n  } else {\n    \n    if ($job.inputs.ref_for_missing) {\n   return '--ref-for-missing ' + $job.inputs.ref_for_missing\n    } else {\n      return ''\n    }\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Input files",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "VCF, VCF.GZ",
            "type": [
              {
                "items": "File",
                "type": "array"
              }
            ],
            "required": true,
            "description": "Input files for merging in compressed format (.vcf.gz).",
            "id": "#input_files",
            "inputBinding": {
              "itemSeparator": " ",
              "position": 10,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  com=''\n  \n  for (i = 0; i<$job.inputs.input_files.length; i++) {\n  \n  ext = $job.inputs.input_files[i].path.split('.').pop()\n  \n  \tif (ext == 'vcf') {\n     \n  \t\tcom+=$job.inputs.input_files[i].path.split('/').pop() +'.gz '\n    \n    } else {\n      \n      com+=$job.inputs.input_files[i].path.split('/').pop() + ' '\n      \n    }\n  }\n  return com\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "File Input"
          },
          {
            "label": "Compressed output",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "FALSE",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "Check to make the output compressed (usually for further processing).",
            "id": "#compressed",
            "sbg:category": "Execution"
          },
          {
            "label": "Collapse",
            "description": "Treat as identical sites with differing alleles [any].",
            "sbg:toolDefaultValue": "any",
            "type": [
              "null",
              {
                "symbols": [
                  "snps",
                  "indels",
                  "both",
                  "any"
                ],
                "name": "collapse",
                "type": "enum"
              }
            ],
            "required": false,
            "sbg:altPrefix": "-c",
            "id": "#collapse",
            "inputBinding": {
              "position": 2,
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  arr = [].concat($job.inputs.input_files);\n \n  if (arr.length == 1) {\n    \n    return ''\n    \n  } else {\n    \n    if ($job.inputs.collapse) {\n   \t\treturn '--collapse ' + $job.inputs.collapse\n    } else {\n     return '' \n    }\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          }
        ],
        "sbg:latestRevision": 14,
        "sbg:toolkit": "VCFtools",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://vcftools.github.io"
          },
          {
            "label": "Download",
            "id": "https://github.com/vcftools/vcftools/zipball/master"
          },
          {
            "label": "Publication",
            "id": "http://bioinformatics.oxfordjournals.org/content/27/15/2156"
          },
          {
            "label": "Wiki",
            "id": "https://sourceforge.net/p/vcftools/wiki/Home/"
          },
          {
            "label": "Source Code",
            "id": "https://github.com/vcftools/vcftools/blob/master/src/perl/vcf-merge"
          }
        ],
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "54cb823ba25a",
            "dockerPull": "images.sbgenomics.com/ognjenm/vcftools:0.1.14",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          {
            "engine": "#cwl-js-engine",
            "class": "Expression",
            "script": "{\n  \n  com=''\n  arr = [].concat($job.inputs.input_files)\n  \n  for (i = 0; i<arr.length; i++) {\n  \n  ext = arr[i].path.split('.').pop()\n  \n    fullname=arr[i].path\n    paths=fullname.split('/')\n\tname = fullname.split('/')[paths.length-1]\n        \n  \tif (ext == 'vcf') {\n     \n        // Bgzipping\n  \t\tcom+='bgzip'\n  \t\tcom+=' -c -f '\n\n  \t\tcom+=fullname\n        name += '.gz'\n        com+=' > '+name\n  \t    com+=' && '\n    \n  \t}\n    \n    // Indexing\n    com+='tabix -f ' + name.split('/').pop()\n    com+=' && '\n    \n  }\n  \n    \tcom+='vcf-merge'\n  \n  return com\n}"
          }
        ],
        "sbg:toolAuthor": "Adam Auton, Petr Danecek, Anthony Marcketta",
        "sbg:revisionNotes": "Add metadata inheriting from input VCFs.",
        "sbg:modifiedBy": "uros_sipetic",
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "engineCommand": "cwl-engine.js",
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ],
        "x": 454.1666919557671,
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "VCF-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "bix-demo/vcftools-0-1-14-demo",
        "sbg:sbgMaintained": false,
        "label": "VCFtools Merge",
        "sbg:license": "GNU General Public License version 3.0 (GPLv3)",
        "sbg:createdOn": 1450911605,
        "sbg:createdBy": "bix-demo",
        "sbg:id": "bix-demo/vcftools-0-1-14-demo/vcftools-merge-0-1-14/14",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "vcf_header": {
              "path": "vcf.cf",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "ref_for_missing": "",
            "silent": false,
            "compressed": false,
            "trim": false,
            "input_files": [
              {
                "path": "sample2.realigned.vcf",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              },
              {
                "path": "custard.realigned.vcf",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              }
            ],
            "collapse": null,
            "remove_duplicates": false
          }
        },
        "id": "bix-demo/vcftools-0-1-14-demo/vcftools-merge-0-1-14/14",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1450911605,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911605,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911606,
            "sbg:revisionNotes": null,
            "sbg:revision": 2,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911606,
            "sbg:revisionNotes": null,
            "sbg:revision": 3,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911607,
            "sbg:revisionNotes": null,
            "sbg:revision": 4,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911608,
            "sbg:revisionNotes": null,
            "sbg:revision": 5,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1472815584,
            "sbg:revisionNotes": "Fixed formatting.",
            "sbg:revision": 6,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1472818436,
            "sbg:revisionNotes": "Changed collapse to enum",
            "sbg:revision": 7,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1473083966,
            "sbg:revisionNotes": "Corrected filename?",
            "sbg:revision": 8,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1473092601,
            "sbg:revisionNotes": "Changed errors for multiple files",
            "sbg:revision": 9,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1473862403,
            "sbg:revisionNotes": "Made compressible output",
            "sbg:revision": 10,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1473867928,
            "sbg:revisionNotes": "Inputs are possibly GZ",
            "sbg:revision": 11,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1473869322,
            "sbg:revisionNotes": "Linked input",
            "sbg:revision": 12,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1493121667,
            "sbg:revisionNotes": "Fixed error --ref-for-missing",
            "sbg:revision": 13,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1499270996,
            "sbg:revisionNotes": "Add metadata inheriting from input VCFs.",
            "sbg:revision": 14,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:cmdPreview": "bgzip -c -f sample2.realigned.vcf > sample2.realigned.vcf.gz && tabix -f sample2.realigned.vcf.gz && bgzip -c -f custard.realigned.vcf > custard.realigned.vcf.gz && tabix -f custard.realigned.vcf.gz && vcf-merge sample2.realigned.vcf.gz custard.realigned.vcf.gz   > sample_unknown_.realigned.merged.vcf",
        "sbg:projectName": "VCFtools 0.1.14 - Demo",
        "sbg:modifiedOn": 1499270996,
        "class": "CommandLineTool",
        "sbg:revision": 14,
        "arguments": [
          {
            "position": 20,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  arr = [].concat($job.inputs.input_files);\n  \n  function common_end(strs) {\n  \n  \t// Find minimum length of file name\n  \n  \tls = [];\n    whole = [];\n\tfor (i=0;i<strs.length;i++){\n  \t\tls = ls.concat(strs[i].path.split('/').pop().length);\n        whole = whole.concat(strs[i].path.length);\n  \t}\n \tl = Math.min.apply(Math,ls);\n  \n  \t// Loop from the end through characters and check if they are the same for all\n  \n \tind = 0;\n \tflag = 0;\n \tfor (i=1;i<=l;i++){\n    \tfor (j=1;j<strs.length;j++){\n      \t\tif (strs[0].path[whole[0]-i]!=strs[j].path[whole[j]-i]){\n        \tflag = 1;\n        \tbreak\n      \t\t}\n   \t\t}\n   \t \tif (flag == 1){\n   \t \t  \tbreak\n   \t    } else {\n      \t\tind = ind + 1;\n        }\n  \t }\n  \n  // Assign and return longest ending common substring\n  if (ind>0) {\n  \tcomstr = strs[0].path.slice(-ind);\n  } else {\n    comstr = 'different_extensions'\n  }\n  \n  return comstr\n  \n  }\n  \n  \n  if(arr.length==1) { \n    new_filename = arr[0].path.split('/').pop()    \n  } else {\n\n    if (arr[0].metadata){  \n \t \t  if (arr[0].metadata[\"sample_id\"]){        \n  \t\t\t prefix = arr[0].metadata[\"sample_id\"];   \n   \t\t  } else {\n   \t\t\t prefix = 'sample_unknown';\n \t      }\n    } else {\n      \n     prefix = 'sample_unknown';\n      \n    }\n\n  \n  // Create joint name and add the merged suffix\n  \n  joint_name = prefix + '_' + common_end(arr);\n  new_filename = joint_name.split('.').slice(0,-1).join('.') + '.merged.vcf'\n  \n  }\n\n    return  '> ' + new_filename;\n\n\n}"
            }
          },
          {
            "position": 25,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  \n  com = ''\n  if ($job.inputs.compressed) {\n  \n  arr = [].concat($job.inputs.input_files);\n  \n  function common_end(strs) {\n  \n  \t// Find minimum length of file name\n  \n  \tls = [];\n    whole = [];\n\tfor (i=0;i<strs.length;i++){\n  \t\tls = ls.concat(strs[i].path.split('/').pop().length);\n        whole = whole.concat(strs[i].path.length);\n  \t}\n \tl = Math.min.apply(Math,ls);\n  \n  \t// Loop from the end through characters and check if they are the same for all\n  \n \tind = 0;\n \tflag = 0;\n \tfor (i=1;i<=l;i++){\n    \tfor (j=1;j<strs.length;j++){\n      \t\tif (strs[0].path[whole[0]-i]!=strs[j].path[whole[j]-i]){\n        \tflag = 1;\n        \tbreak\n      \t\t}\n   \t\t}\n   \t \tif (flag == 1){\n   \t \t  \tbreak\n   \t    } else {\n      \t\tind = ind + 1;\n        }\n  \t }\n  \n  // Assign and return longest ending common substring\n  if (ind>0) {\n  \tcomstr = strs[0].path.slice(-ind);\n  } else {\n    comstr = 'different_extensions'\n  }\n  \n  return comstr\n  \n  }\n  \n  \n  if(arr.length==1) { \n    new_filename = arr[0].path.split('/').pop()    \n  } else {\n\n    if (arr[0].metadata){  \n \t \t  if (arr[0].metadata[\"sample_id\"]){        \n  \t\t\t prefix = arr[0].metadata[\"sample_id\"];   \n   \t\t  } else {\n   \t\t\t prefix = 'sample_unknown';\n \t      }\n    } else {\n      \n     prefix = 'sample_unknown';\n      \n    }\n\n  \n  // Create joint name and add the merged suffix\n  \n  joint_name = prefix + '_' + common_end(arr);\n  new_filename = joint_name.split('.').slice(0,-1).join('.') + '.merged.vcf'\n  \n  }\n\n   com += '&& bgzip -c -f '\n   com += new_filename\n   com += ' > ' + new_filename + '.gz'\n\n  }\n  return com\n\n\n}\n    \n\n"
            }
          }
        ],
        "sbg:validationErrors": [],
        "description": "VCFtools merge merges two or more VCF files into one so that if two source files had one column each, the output will print a single file with two columns. \nNote that this script is not intended for concatenating VCF files. For this, use vcf-concat instead.",
        "sbg:image_url": null,
        "y": 271.7862767009077,
        "sbg:contributors": [
          "bix-demo",
          "ognjenm",
          "uros_sipetic"
        ],
        "appUrl": "/u/bix-demo/vcftools-0-1-14-demo/apps/#bix-demo/vcftools-0-1-14-demo/vcftools-merge-0-1-14/14"
      },
      "inputs": [
        {
          "id": "#VCFtools_Merge.vcf_header"
        },
        {
          "id": "#VCFtools_Merge.trim"
        },
        {
          "id": "#VCFtools_Merge.silent"
        },
        {
          "id": "#VCFtools_Merge.remove_duplicates"
        },
        {
          "id": "#VCFtools_Merge.regions"
        },
        {
          "id": "#VCFtools_Merge.ref_for_missing"
        },
        {
          "id": "#VCFtools_Merge.input_files",
          "source": [
            "#Bcftools_Filter.output_file"
          ]
        },
        {
          "id": "#VCFtools_Merge.compressed"
        },
        {
          "id": "#VCFtools_Merge.collapse"
        }
      ],
      "outputs": [
        {
          "id": "#VCFtools_Merge.output_file"
        }
      ],
      "sbg:x": 454.1666919557671,
      "sbg:y": 271.7862767009077
    },
    {
      "id": "#VCFtools_Sort_1",
      "run": {
        "outputs": [
          {
            "label": "Output file",
            "outputBinding": {
              "glob": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  filepath = $job.inputs.input_file.path\n\n  filename = filepath.split(\"/\").pop();\n\n  file_dot_sep = filename.split(\".\");\n  file_ext = file_dot_sep[file_dot_sep.length-1];\n\n  new_filename = filename.substr(0,filename.lastIndexOf(\".vcf\")) + \".sorted.vcf\";\n\n  if ($job.inputs.compressed) {\n      new_filename += \".gz\";\n  }\n  \n  return new_filename;\n  \n}"
              },
              "sbg:inheritMetadataFrom": "#input_file",
              "sbg:metadata": {
                "__inherit__": "input_file"
              },
              "secondaryFiles": [
                ".tbi"
              ]
            },
            "type": [
              "null",
              "File"
            ],
            "id": "#output_file",
            "sbg:fileTypes": "VCF, VCF.GZ"
          }
        ],
        "sbg:toolkitVersion": "0.1.14",
        "inputs": [
          {
            "label": "Parallel threads",
            "sbg:toolDefaultValue": "1",
            "type": [
              "null",
              "int"
            ],
            "required": false,
            "description": "Change the number of sorts run concurrently to <int>.",
            "id": "#parallel",
            "inputBinding": {
              "position": 2,
              "separate": true,
              "prefix": "-p",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Execution"
          },
          {
            "label": "Memory in MB",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "N/A",
            "type": [
              "null",
              "int"
            ],
            "required": false,
            "description": "Memory in MB for execution.",
            "id": "#mem_mb",
            "sbg:category": "Execution"
          },
          {
            "label": "Input file",
            "sbg:fileTypes": "VCF, VCF.GZ",
            "type": [
              "File"
            ],
            "required": true,
            "description": "Input file (vcf or vcf.gz)",
            "id": "#input_file",
            "inputBinding": {
              "position": 1,
              "separate": false,
              "sbg:cmdInclude": true,
              "secondaryFiles": []
            }
          },
          {
            "label": "Compressed output",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "FALSE",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "Check to make the output compressed (usually for further processing).",
            "id": "#compressed",
            "sbg:category": "Execution"
          },
          {
            "label": "Chromosomal order",
            "type": [
              "null",
              "boolean"
            ],
            "required": false,
            "description": "Use natural ordering (1,2,10,MT,X) rather then the default (1,10,2,MT,X). This requires                                      new version of the unix \"sort\" command which supports the --version-sort option.",
            "id": "#chromosomal_order",
            "inputBinding": {
              "position": 0,
              "separate": true,
              "prefix": "-c",
              "sbg:cmdInclude": true
            }
          }
        ],
        "sbg:latestRevision": 8,
        "sbg:toolkit": "VCFtools",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://vcftools.github.io"
          },
          {
            "label": "Source code",
            "id": "https://github.com/vcftools/vcftools"
          },
          {
            "label": "Publications",
            "id": "http://bioinformatics.oxfordjournals.org/content/27/15/2156"
          }
        ],
        "hints": [
          {
            "value": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.parallel) {\n  \treturn $job.inputs.parallel\n  } else {\n    return 1\n  }  \n}"
            },
            "class": "sbg:CPURequirement"
          },
          {
            "value": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.mem_mb) {\n    \n    return $job.inputs.mem_mb\n    \n   }  else {\n      \n      return 1000\n      \n      }\n}"
            },
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "54cb823ba25a",
            "dockerPull": "images.sbgenomics.com/ognjenm/vcftools:0.1.14",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          "vcf-sort"
        ],
        "sbg:toolAuthor": "Adam Auton, Petr Danecek, Anthony Marcketta",
        "sbg:revisionNotes": "Added tabix indexing",
        "sbg:modifiedBy": "ognjenm",
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "engineCommand": "cwl-engine.js",
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ],
        "x": 9.999998450279294,
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "VCF-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "bix-demo/vcftools-0-1-14-demo",
        "sbg:sbgMaintained": false,
        "label": "VCFtools Sort",
        "sbg:license": "GNU General Public License version 3.0 (GPLv3)",
        "sbg:createdOn": 1450911603,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "bix-demo",
        "sbg:id": "bix-demo/vcftools-0-1-14-demo/vcftools-sort-0-1-14/8",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 2,
            "mem": 100
          },
          "inputs": {
            "parallel": 2,
            "input_file": {
              "path": "sample1.vcf"
            },
            "mem_mb": 100,
            "compressed": true
          }
        },
        "id": "bix-demo/vcftools-0-1-14-demo/vcftools-sort-0-1-14/8",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1450911603,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911604,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1450911604,
            "sbg:revisionNotes": null,
            "sbg:revision": 2,
            "sbg:modifiedBy": "bix-demo"
          },
          {
            "sbg:modifiedOn": 1472821172,
            "sbg:revisionNotes": "Changed memory, CPU and added parallel",
            "sbg:revision": 3,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1474285644,
            "sbg:revisionNotes": "Compressable output",
            "sbg:revision": 4,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1478007439,
            "sbg:revisionNotes": "Changed --parallel to -p",
            "sbg:revision": 5,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1480089729,
            "sbg:revisionNotes": "Changed CPU",
            "sbg:revision": 6,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1482334199,
            "sbg:revisionNotes": "Added inherit metadata from input.",
            "sbg:revision": 7,
            "sbg:modifiedBy": "milan.domazet.sudo"
          },
          {
            "sbg:modifiedOn": 1509011494,
            "sbg:revisionNotes": "Added tabix indexing",
            "sbg:revision": 8,
            "sbg:modifiedBy": "ognjenm"
          }
        ],
        "sbg:cmdPreview": "vcf-sort sample1.vcf  > sample1.sorted.vcf  && bgzip -c -f sample1.sorted.vcf > sample1.sorted.vcf.gz && tabix sample1.sorted.vcf.gz",
        "sbg:projectName": "VCFtools 0.1.14 - Demo",
        "sbg:modifiedOn": 1509011494,
        "class": "CommandLineTool",
        "sbg:revision": 8,
        "arguments": [
          {
            "position": 100,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n\n\n  if ($job.inputs.compressed) {\n    \n  \tfilepath = $job.inputs.input_file.path\n\n  \tfilename = filepath.split(\"/\").pop();\n\n  \tfile_dot_sep = filename.split(\".\");\n  \tfile_ext = file_dot_sep[file_dot_sep.length-1];\n\n  \tnew_filename = filename.substr(0,filename.lastIndexOf(\".vcf\")) + \".sorted.vcf\";\n    out = new_filename + '.gz'\n  \treturn '&& bgzip -c -f ' + new_filename + ' > ' + out + ' && tabix ' + out\n      \n  }\n  \n  \n  \n}"
            }
          },
          {
            "position": 50,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  filepath = $job.inputs.input_file.path\n\n  filename = filepath.split(\"/\").pop();\n\n  file_dot_sep = filename.split(\".\");\n  file_ext = file_dot_sep[file_dot_sep.length-1];\n\n  new_filename = filename.substr(0,filename.lastIndexOf(\".vcf\")) + \".sorted.vcf\";\n  \n  return '> '+new_filename;\n  \n}"
            }
          }
        ],
        "sbg:validationErrors": [],
        "description": "VCFtools sort sorts a VCF file.",
        "sbg:image_url": null,
        "y": 332.519480987221,
        "sbg:contributors": [
          "bix-demo",
          "ognjenm",
          "milan.domazet.sudo"
        ],
        "appUrl": "/u/bix-demo/vcftools-0-1-14-demo/apps/#bix-demo/vcftools-0-1-14-demo/vcftools-sort-0-1-14/8"
      },
      "inputs": [
        {
          "id": "#VCFtools_Sort_1.parallel"
        },
        {
          "id": "#VCFtools_Sort_1.mem_mb"
        },
        {
          "id": "#VCFtools_Sort_1.input_file",
          "source": [
            "#VCFtools_Keep_SNPs_or_Indels.output_file"
          ]
        },
        {
          "id": "#VCFtools_Sort_1.compressed"
        },
        {
          "id": "#VCFtools_Sort_1.chromosomal_order",
          "default": true
        }
      ],
      "outputs": [
        {
          "id": "#VCFtools_Sort_1.output_file"
        }
      ],
      "sbg:x": 9.999998450279294,
      "sbg:y": 332.519480987221,
      "scatter": "#VCFtools_Sort_1.input_file"
    },
    {
      "id": "#SBG_SciClone_report",
      "run": {
        "outputs": [
          {
            "label": "Tumor heterogeneity report",
            "sbg:fileTypes": "TXT, CSV, TSV",
            "type": [
              "null",
              "File"
            ],
            "description": "A report containing information about the tumor samples (purity, MATH scores, cluster means and number of mutations per cluster).",
            "id": "#tumor_heterogeneity_report",
            "outputBinding": {
              "glob": "{*.csv,*.txt,*.tsv}",
              "sbg:inheritMetadataFrom": "#input_clusters"
            }
          }
        ],
        "sbg:toolkitVersion": "V1.0",
        "inputs": [
          {
            "label": "VAF low cutoff",
            "type": [
              "null",
              "float"
            ],
            "description": "Lower limit on VAFs for MATH score calculation.",
            "id": "#vaf_filt_lo",
            "inputBinding": {
              "position": 20,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.report_type == \"version_1\"){return \"-vafLow \" + $job.inputs.vaf_filt_lo}\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "VAF high cutoff",
            "type": [
              "null",
              "float"
            ],
            "description": "Upper limit on the VAFs for MATH score calculation.",
            "id": "#vaf_filt_hi",
            "inputBinding": {
              "position": 15,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.report_type == \"version_1\"){return \"-vafHigh \" + $job.inputs.vaf_filt_hi}\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Report format",
            "description": "Format of the report to be outputted.",
            "type": [
              {
                "symbols": [
                  "version_1",
                  "version_2",
                  "cancer_version"
                ],
                "name": "report_type",
                "type": "enum"
              }
            ],
            "id": "#report_type",
            "sbg:category": "Inputs"
          },
          {
            "label": "Report name",
            "sbg:toolDefaultValue": "Inferred from input filename",
            "id": "#report_name",
            "description": "Name of the output report",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 25,
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  var x = [].concat($job.inputs.input_clusters)[0].path.split('/').pop().split('.').slice(0,-1).join('.')\n  return $job.inputs.report_name ? '-fn ' + $job.inputs.report_name : '-fn ' + x\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Project ID",
            "sbg:includeInPorts": true,
            "type": [
              "null",
              "string"
            ],
            "required": false,
            "description": "ID of the project.",
            "id": "#project_id",
            "inputBinding": {
              "position": 0,
              "separate": true,
              "prefix": "-p",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Clusters file",
            "type": [
              "File"
            ],
            "required": true,
            "description": "Clusters file, as outputted by sciClone.",
            "id": "#input_clusters",
            "inputBinding": {
              "position": 0,
              "separate": true,
              "prefix": "-c",
              "secondaryFiles": [],
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Coverage",
            "sbg:includeInPorts": true,
            "type": [
              "null",
              "int"
            ],
            "required": false,
            "description": "Coverage used in the sciClone clustering procedure.",
            "id": "#coverage",
            "inputBinding": {
              "position": 0,
              "separate": true,
              "prefix": "-cov",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Cluster summaries",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "required": false,
            "description": "Cluster summary files, as outputted by sciClone.",
            "id": "#clusterSummary",
            "inputBinding": {
              "position": 0,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  if ($job.inputs.report_type == \"version_1\"){\n    for (i=0;i < $job.inputs.clusterSummary.length;i++){\n      file_name = $job.inputs.clusterSummary[i].path.split(\"/\")[$job.inputs.clusterSummary[i].path.split(\"/\").length - 1]\n      if (file_name.split(\".\")[file_name.split(\".\").length -1] == \"means\"){\n      return \"-means \" + $job.inputs.clusterSummary[i].path\n      }\n    }\n  }\n  if ($job.inputs.report_type != \"version_1\"){\n  to_return = \"\"\n  for(i=0;i < $job.inputs.clusterSummary.length;i++){\n    if ($job.inputs.clusterSummary[i].path.endsWith(\".lower\")){\n      to_return = to_return+\"-l \"+$job.inputs.clusterSummary[i].path + \" \"\n    }\n    if ($job.inputs.clusterSummary[i].path.endsWith(\".means\")){\n      to_return = to_return+\"-m \"+$job.inputs.clusterSummary[i].path + \" \"\n    }\n    if ($job.inputs.clusterSummary[i].path.endsWith(\".upper\")){\n      to_return = to_return+\"-u \"+$job.inputs.clusterSummary[i].path + \" \"\n    }\n    \n   }\n  return to_return\n  }\n  \n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Clonal evolution models",
            "sbg:fileTypes": "TXT",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "Clonal evolution models, represented in a text tile, as outputted by Fishplot.",
            "id": "#clonal_evolution_models",
            "inputBinding": {
              "position": 2,
              "separate": true,
              "prefix": "-cem",
              "secondaryFiles": [],
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          }
        ],
        "sbg:latestRevision": 5,
        "sbg:toolkit": "SBGtools",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerPull": "images.sbgenomics.com/danilo_jovanovic/r_pip_pandas_statistics",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          {
            "engine": "#cwl-js-engine",
            "class": "Expression",
            "script": "{\n  if($job.inputs.report_type == \"version_1\"){return \"Rscript Report.R\"}\n  if($job.inputs.report_type == \"version_2\"){return \"python report.py\"}\n  if($job.inputs.report_type == \"cancer_version\"){return \"python cancer_report.py\"}\n  \n\n\n}"
          }
        ],
        "sbg:toolAuthor": "Seven Bridges Genomics",
        "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/21",
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:copyOf": "uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/21",
        "x": 1312.4991893470726,
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "Other"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:sbgMaintained": false,
        "label": "SBG SciClone report",
        "sbg:license": "GNU General Public License v3.0 only",
        "sbg:createdOn": 1510329400,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "uros_sipetic",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-sciclone-report/5",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "vaf_filt_lo": null,
            "report_type": "version_2",
            "input_clusters": {
              "path": "/path/to/normal.tumor.strelka.clusters",
              "size": 0,
              "metadata": {
                "normal_id": "M",
                "case_id": "ddaf",
                "gender": "yess",
                "sample_type": "TTTTUMOR TYPE"
              },
              "secondaryFiles": [],
              "class": "File"
            },
            "coverage": 7,
            "project_id": "",
            "vaf_filt_hi": null,
            "clusterSummary": [
              {
                "path": "sample.cluster.summary.lower",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              },
              {
                "path": "sample.cluster.summary.means",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              },
              {
                "path": "sample.cluster.summary.upper",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              }
            ],
            "report_name": ""
          }
        },
        "id": "bix-demo/sbgtools-demo/sbg-sciclone-report/5",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1510329400,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/16",
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1517826357,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/17",
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1517927504,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/18",
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1518548842,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/19",
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1518559040,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/20",
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1520515573,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-report/21",
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:cmdPreview": "python report.py -c /path/to/normal.tumor.strelka.clusters -s yess -sid ddaf -sty TTTTUMOR_TYPE -nid M",
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:modifiedOn": 1520515573,
        "class": "CommandLineTool",
        "sbg:revision": 5,
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "arguments": [
          {
            "position": 0,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n\n  if($job.inputs.input_clusters.metadata[\"sex\"]){return $job.inputs.input_clusters.metadata[\"sex\"]}\n  else if($job.inputs.input_clusters.metadata[\"Sex\"]){return $job.inputs.input_clusters.metadata[\"Sex\"]}\n  else if($job.inputs.input_clusters.metadata[\"gender\"]){return $job.inputs.input_clusters.metadata[\"gender\"]}\n  else if($job.inputs.input_clusters.metadata[\"Gender\"]){return $job.inputs.input_clusters.metadata[\"Gender\"]}\n  else{ return \"NA\"}\n\n}"
            },
            "prefix": "-s"
          },
          {
            "position": 0,
            "separate": false,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n\n  if ($job.inputs.input_clusters.metadata[\"case_id\"]){\n  \n    if($job.inputs.report_type == \"version_2\"){\n    return \"-sid \" + $job.inputs.input_clusters.metadata[\"case_id\"]\n    }\n  \n    if($job.inputs.report_type == \"cancer_version\"){\n    return \"-cid \" + $job.inputs.input_clusters.metadata[\"case_id\"]\n    }\n  }\n\n}"
            }
          },
          {
            "position": 50,
            "separate": false,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.input_clusters.metadata[\"sample_type\"]){\n  \n    if($job.inputs.report_type == \"version_2\"){\n    return \"-sty \" + $job.inputs.input_clusters.metadata.sample_type.replace(/\\s+/g, '_')\n    }\n  }\n}"
            }
          },
          {
            "position": 55,
            "separate": false,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.input_clusters.metadata[\"normal_id\"]){\n    return \"-nid \" + $job.inputs.input_clusters.metadata[\"normal_id\"]\n  }\n}"
            }
          }
        ],
        "sbg:validationErrors": [],
        "description": "This tool produces a report with information about the tumor sample (purity, MATH score, cluster means and number of mutations per cluster).\n\n### Commons Issues ###\nNone",
        "sbg:image_url": null,
        "y": 580.0191304672263,
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          },
          {
            "fileDef": [
              {
                "fileContent": "args = commandArgs(trailingOnly=TRUE)\n\nif (\"-means\" %in% args){\n  input_means = unlist(strsplit(args[match(\"-means\",args)+1], \",\"))\n}\nif (\"-c\" %in% args){\n  input_file = unlist(strsplit(args[match(\"-c\",args)+1], \",\"))\n}\n\n\nif (\"-vafHigh\" %in% args){\n  vafCutOffHigh = as.integer(args[match(\"-max_clust\",args)+1])\n}else{\n  vafCutOffHigh = 0.99}\n\nif (\"-vafLow\" %in% args){\n  vafCutOffLow = as.integer(args[match(\"-max_clust\",args)+1])\n}else{\n  vafCutOffLow = 0.05}\n\n\nmeans = read.table(input_means,sep=\"\\t\",header=T,colClasses = \"character\")\n\n\npurity_df = \"Purity\"\nfor (i in 2:length(means[1,])){\n  purity = max(as.numeric(means[,i]))*200\n  if(purity > 100){purity = 100}\n  else{purity = round(purity, digits=2)}\n  #purity_df[nrow(purity_df)+1, ] <- c(colnames(means[i]),purity)\n  purity_df[i] = purity\n}\npurity_df[length(purity_df)+1] = \"X\"\ninput_data = read.table(input_file,header = T)\nvaf_cols = colnames(input_data)[grep(\"\\\\.vaf\",colnames(input_data))]\n\nmath_output = \"MATH\"\n\nfor(i in 1:length(vaf_cols)){\n  vaf=unlist(input_data[vaf_cols[i]])\n  \n  print(\"Normalizing VAFs\")\n  if(max(vaf, na.rm = TRUE) > 1){\n    vaf = vaf/100\n  }\n  \n  if(vafCutOffLow>0){\n    print(\"Filtering out low VAFs\")\n    vaf = vaf[!(vaf < vafCutOffLow)]\n  }\n  if(vafCutOffHigh<1){\n    print(\"Filtering out high VAFs\")\n    vaf = vaf[!(vaf > vafCutOffHigh)]\n  }\n  pid = vaf_cols[i]\n  math.df = data.frame()\n  abs.med.dev = abs(vaf - median(vaf)) #absolute deviation from median vaf\n  pat.mad = median(abs.med.dev) * 100\n  pat.math = pat.mad * 1.4826 /median(vaf)\n\n  math_output[i+1] = pat.math\n}\nmath_output[length(math_output)+1] = \"X\"\n\n\n\n\n#################################################################################\n\nnumber_of_clusters = length(means[,1])\nnumber_of_samples = length(means[1,])-1\ncluster_separator = \",\"\ninfo_separator = \"-\"\n\nclusters <- input_data$cluster\nclusters = clusters[!is.na(clusters)]\n\ncluster_info <- data.frame(Sample = numeric(0),Cluster_info = numeric(0))\n\nnum_of_mut = 0\nfor(j in 1:number_of_clusters){\n  num_of_mut[j] = length(clusters[clusters == j])\n  \n}\n\n\n\nrbind(purity_df,math_output)\nfinal_output = means\n\n\nfinal_output[,\"Number of mutations\"] <- num_of_mut\nfinal_output <- droplevels(final_output)\n\nfinal_output[length(final_output[,1])+1,] = math_output\nfinal_output[length(final_output[,1])+1,] = purity_df\n\nif (\"-fn\" %in% args){\n  report_name = (args[match(\"-fn\",args)+1])\n}else{\n  report_name = colnames(final_output)[2]}\n\n\nwrite.table(final_output,file = paste(report_name,\".tumor_heterogeneity_report.txt\",sep=\"\"), col.names = T, row.names = F, sep = \"\\t\", quote = F)",
                "filename": "Report.R"
              },
              {
                "fileContent": "\"\"\"\nThis module generates a report from data collected from clusters and summary\nfiles for the cancer pipeline\n\"\"\"\nimport argparse\nimport statistics\nimport six\nimport pandas\n\nparser = argparse.ArgumentParser(\n    description='Generate report')\n\nparser.add_argument(\n    '-nid',\n    '--normal_id',\n    help='Normal ID from normal_id metadata',\n    default=\"NA\"\n)\n\nparser.add_argument(\n    '-cov',\n    '--coverage',\n    help='Coverage',\n    default=0\n)\n\nparser.add_argument(\n    '-s',\n    '--sex',\n    help='Sex',\n    default=\"NA\"\n)\n\nparser.add_argument(\n    '-p',\n    '--proj_id',\n    help='Project ID',\n    default='NA'\n)\n\nparser.add_argument(\n    '-fn',\n    '--file_name',\n    help='Name of the report file',\n    default=\"Report\"\n)\n\nparser.add_argument(\n    '-cid',\n    '--case_id',\n    help='Case ID (case_id metadata)',\n    default=\"missing case_id metadata\"\n)\n\nparser.add_argument(\n    '-l',\n    '--lower',\n    help='Summary lower path',\n    required=True\n)\n\nparser.add_argument(\n    '-u',\n    '--upper',\n    help='Summary upper path',\n    required=True\n)\n\nparser.add_argument(\n    '-m',\n    '--means',\n    help='Summary means path',\n    required=True\n)\n\nparser.add_argument(\n    '-c',\n    '--clusters',\n    help='Clusters file',\n    required=True\n)\n\n\ndef write_num_of_mutations(in_clusters_file, df):\n    \"\"\"\n    Function that adds number of mutations to pandas dataframe\n    :param df: pandas dataframe\n    :param in_clusters_file: file path\n    :return: number of rows/mutations\n    \"\"\"\n    file = pandas.read_csv(in_clusters_file, sep=\"\\t\", index_col=0, header=0)\n    mutations = file[\"cluster\"].values\n    mutations = [six.text_type(int(mutation)) for mutation in mutations if\n                 pandas.notnull(mutation)]\n    mut_dict = {}\n    for mutation in mutations:\n        if pandas.notnull(mutation):\n            if mutation not in mut_dict.keys():\n                mut_dict[mutation] = 1\n            else:\n                mut_dict[mutation] += 1\n    for cluster in sorted(list(mut_dict.keys())):\n        df[\"cluster\"+cluster+\" number of mutations\"] = mut_dict[cluster]\n\n\ndef calc_purity(file_location, in_sample_names):\n    \"\"\"\n    Function calculates tumor purity and normalises to 100%\n    :param file_location: Path to input file [string]\n    :param in_sample_names:  Names of samples used [list of strings]\n    :return: Dict of purities with samples for keys\n    \"\"\"\n    means = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    purity = means.loc['cluster1']\n    for sample_name in in_sample_names:\n        purity[sample_name] *= 200\n        if purity[sample_name] > 100:\n            purity[sample_name] = 100\n    return purity\n\n\ndef dict_to_df_col(df, in_dict, column):\n    \"\"\"\n    Function that writes a new column to a dataframe keyed by\n    input dict (in_dict) keys\n    :param df: Input dataframe\n    :param in_dict: dictionary to be written\n    :param column: name of the column\n    :return:\n    \"\"\"\n    df[column] = 0\n    for key in in_dict:\n        df[column].loc[key] = in_dict[key]\n    return df\n\n\ndef get_maxclust_cluster(file_location):\n    \"\"\"\n    Function that returns the maximum number of clusters in all samples.\n    :param file_location: Path to input file [string]\n    :return: maximum number of clusters [integer]\n    \"\"\"\n    file = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    clusters = file['cluster']\n    clusters = clusters.max()\n    return int(clusters)\n\n\ndef write_clusters(df, file_location):\n    \"\"\"\n    Function that adds cluster info columns per sample to pandas DataFrame\n    :param df: input pandas DataFrame\n    :param file_location: Path to input file [string]\n    \"\"\"\n    file = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    for cluster in file.index.values:\n        col_name = cluster + \" \" + file_location.split(\".\").pop()\n        df[col_name] = 0\n        for sample in file.keys():\n            df[col_name].loc[sample] = file[sample].loc[cluster]\n\n\ndef calculate_math(samples, in_clusters_file):\n    \"\"\"\n    Function that calculates MATH scores per sample\n    :param samples: Sample names\n    :param in_clusters_file: Clusters file path\n    :return: MATH score dict\n    \"\"\"\n    file = pandas.read_csv(in_clusters_file, sep=\"\\t\", index_col=0)\n    MATH_scores = {}\n    for sample in samples:\n        vafs = file[sample + \".vaf\"].values\n        if max(vafs) > 1:\n            vafs = [vaf / 100 for vaf in vafs]\n        median_vaf = statistics.median(vafs)\n        abs_med_dev = [abs(vaf - median_vaf) for vaf in vafs]\n        pat_mad = statistics.median(abs_med_dev) * 100\n        MATH_scores[sample] = (pat_mad * 1.4826) / median_vaf\n    return MATH_scores\n\n\nargs = parser.parse_args()\nclust_samples_start = 2\nclust_samples_len = 6\n\nheader = [\"Tumor ID\", \"Project ID\", \"Case ID\", \"Normal ID\", \"Sex\",\n          \"Tumor Purity\", \"Coverage\", \"Number of clusters\"]\n\nclusters_file = open(args.clusters, \"r\")\nclust_header = clusters_file.readline().split(\"\\t\")\nnum_of_samples = int((clust_header.index(\n    \"adequateDepth\") - clust_samples_start) / clust_samples_len)\nsample_names = []\nfor i in range(num_of_samples):\n    sample_names.append(\n        clust_header[clust_samples_start + i * clust_samples_len][:-4])\n\nreport = pandas.DataFrame(columns=header, index=sample_names)\nreport[\"Project ID\"] = args.proj_id\n\nif args.case_id == \"missing case_id metadata\":\n    report[\"Case ID\"] = sample_names[0]\nelse:\n    report[\"Case ID\"] = args.case_id\n\nreport[\"Normal ID\"] = args.normal_id\nreport[\"Sex\"] = args.sex\nreport[\"Tumor ID\"] = sample_names\nreport[\"Tumor Purity\"] = calc_purity(args.means, sample_names)\nreport[\"Coverage\"] = args.coverage\n\nreport[\"Number of clusters\"] = get_maxclust_cluster(args.clusters)\n\nreport = dict_to_df_col(report,\n                        calculate_math(sample_names, args.clusters),\n                        \"MATH Score\")\n\nwrite_num_of_mutations(args.clusters, report)\nwrite_clusters(report, args.means)\n\nreport.to_csv(path_or_buf=args.file_name + \".tumor_heterogeneity_report.tsv\", sep=\"\\t\", index=False,\n              header=True)",
                "filename": "cancer_report.py"
              },
              {
                "fileContent": "\"\"\"\nThis module generates a report from data collected from clusters and summary\nfiles\n\"\"\"\nimport argparse\nimport pandas\nfrom collections import Counter\n\nparser = argparse.ArgumentParser(\n    description='Generate report')\n\nparser.add_argument(\n    '-cem',\n    '--clonal_evolution_models',\n    help='Clonal evolution models, in text format, as inferred by Fishplot. ',\n    default=\"NA\"\n)\n\nparser.add_argument(\n    '-nid',\n    '--normal_id',\n    help='Normal ID from normal_id metadata',\n    default=\"NA\"\n)\n\nparser.add_argument(\n    '-cov',\n    '--coverage',\n    help='Coverage',\n    default=0\n)\n\nparser.add_argument(\n    '-s',\n    '--sex',\n    help='Sex',\n    default=\"NA\"\n)\n\nparser.add_argument(\n    '-p',\n    '--proj_id',\n    help='Project ID',\n    default='NA'\n)\n\nparser.add_argument(\n    '-fn',\n    '--file_name',\n    help='Name of the report file',\n    default=\"Report\"\n)\n\nparser.add_argument(\n    '-sid',\n    '--sample_id',\n    help='Sample ID (case_id metadata)',\n    default=\"missing case_id metadata\"\n)\n\nparser.add_argument(\n    '-sty',\n    '--sample_type',\n    help='Sample type (sample_type metadata)',\n    default=\"tumor\"\n)\n\nparser.add_argument(\n    '-l',\n    '--lower',\n    help='Summary lower path',\n    required=True\n)\n\nparser.add_argument(\n    '-u',\n    '--upper',\n    help='Summary upper path',\n    required=True\n)\n\nparser.add_argument(\n    '-m',\n    '--means',\n    help='Summary means path',\n    required=True\n)\n\nparser.add_argument(\n    '-c',\n    '--clusters',\n    help='Clusters file',\n    required=True\n)\n\n\ndef get_clonal_models(file_location):\n    \"\"\"\n    Function creates a string of clonal evolution models\n    :param file_location: Path to input file [string]\n    :return: String of clonal evolution models\n    \"\"\"\n    x = open(file_location, 'r')\n    s = ''\n    for line in x:\n        s += line.rstrip() + \"; \"\n    return s[0:-2]\n\n\ndef calc_purity(file_location, in_sample_names):\n    \"\"\"\n    Function calculates tumor purity and normalises to 100%\n    :param file_location: Path to input file [string]\n    :param in_sample_names:  Names of samples used [list of strings]\n    :return: Dict of purities with samples for keys\n    \"\"\"\n    means = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    purity = means.loc['cluster1']\n    for sample_name in in_sample_names:\n        purity[sample_name] *= 200\n        if purity[sample_name] > 100:\n            purity[sample_name] = 100\n    return purity\n\n\ndef get_maxclust_cluster(file_location):\n    \"\"\"\n    Function that returns the maximum number of clusters in all samples.\n    :param file_location: Path to input file [string]\n    :return: maximum number of clusters [integer]\n    \"\"\"\n    file = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    clusters = file['cluster']\n    clusters = clusters.max()\n    return int(clusters)\n\n\ndef write_clusters(df, file_location):\n    \"\"\"\n    Function that adds cluster info columns per sample to pandas DataFrame\n    :param df: input pandas DataFrame\n    :param file_location: Path to input file [string]\n    \"\"\"\n    file = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    for cluster in file.index.values:\n        col_name = cluster + \" \" + file_location.split(\".\").pop()\n        df[col_name] = 0\n        for sample in file.keys():\n            df[col_name].loc[sample] = file[sample].loc[cluster]\n\n\ndef write_num_of_mut(df, file_location):\n    file = pandas.read_csv(file_location, sep=\"\\t\", index_col=0)\n    cluster_col = list(file['cluster'].dropna())\n    cluster_col = [elem for elem in cluster_col if elem]\n    count = Counter(cluster_col)\n    for key in sorted(count):\n        k = int(float(str(key)))\n        df[\"cluster \" + str(k) + \" number of mutations\"] = count[key]\n\n\n\nargs = parser.parse_args()\nclust_samples_start = 2\nclust_samples_len = 6\n\nheader = [\"Case ID (USUBJID)\", \"Tumor sample ID (tumor EAName)\",\n          \"Normal sample ID (normal EAName)\", \"Project\", \"Filename\", \"Sex\",\n          \"Tumor Purity\", \"Coverage\", \"Number of clusters\",\n          \"Clonal evolution models\"]\n\nclusters_file = open(args.clusters, \"r\")\nclust_header = clusters_file.readline().split(\"\\t\")\nnum_of_samples = int((clust_header.index(\n    \"adequateDepth\") - clust_samples_start) / clust_samples_len)\nsample_names = []\nfor i in range(num_of_samples):\n    sample_names.append(\n        clust_header[clust_samples_start + i * clust_samples_len][:-4])\n\nreport = pandas.DataFrame(columns=header, index=sample_names)\n\nreport[\"Project\"] = args.proj_id\nreport[\"Case ID (USUBJID)\"] = args.sample_id\nreport[\"Sex\"] = args.sex\nreport[\"Tumor sample ID (tumor EAName)\"] = sample_names\nreport[\"Normal sample ID (normal EAName)\"] = args.normal_id\nreport[\"Filename\"] = args.file_name + '.tumor_heterogeneity_report.tsv'\nreport[\"Tumor Purity\"] = calc_purity(args.means, sample_names)\nreport[\"Coverage\"] = args.coverage\nreport[\"Number of clusters\"] = get_maxclust_cluster(args.clusters)\nif (args.clonal_evolution_models != 'NA'):\n    report[\"Clonal evolution models\"] = get_clonal_models(\n        args.clonal_evolution_models)\nelse:\n    report[\"Clonal evolution models\"] = 'NA'\n\nwrite_num_of_mut(report, args.clusters)\nwrite_clusters(report, args.lower)\nwrite_clusters(report, args.means)\nwrite_clusters(report, args.upper)\n\nreport.to_csv(path_or_buf=args.file_name + \".tumor_heterogeneity_report.tsv\",\n              sep=\"\\t\", index=False,\n              header=True)",
                "filename": "report.py"
              }
            ],
            "class": "CreateFileRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#SBG_SciClone_report.vaf_filt_lo"
        },
        {
          "id": "#SBG_SciClone_report.vaf_filt_hi"
        },
        {
          "id": "#SBG_SciClone_report.report_type",
          "default": "version_2",
          "source": [
            "#report_type"
          ]
        },
        {
          "id": "#SBG_SciClone_report.report_name",
          "source": [
            "#report_name"
          ]
        },
        {
          "id": "#SBG_SciClone_report.project_id",
          "source": [
            "#project_id"
          ]
        },
        {
          "id": "#SBG_SciClone_report.input_clusters",
          "source": [
            "#SciClone_1_1.clusters"
          ]
        },
        {
          "id": "#SBG_SciClone_report.coverage",
          "source": [
            "#SBG_SciClone_Parameters.read_depth"
          ]
        },
        {
          "id": "#SBG_SciClone_report.clusterSummary",
          "source": [
            "#SciClone_1_1.clusterSummary"
          ]
        },
        {
          "id": "#SBG_SciClone_report.clonal_evolution_models",
          "source": [
            "#Fishplot_0_3.clonal_evolution_models"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_SciClone_report.tumor_heterogeneity_report"
        }
      ],
      "sbg:x": 1312.4991893470726,
      "sbg:y": 580.0191304672263
    },
    {
      "id": "#VCFtools_Keep_SNPs_or_Indels",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "Output VCF",
            "sbg:fileTypes": "VCF",
            "type": [
              "null",
              "File"
            ],
            "description": "VCF file containing only required type of variants.",
            "id": "#output_file",
            "outputBinding": {
              "glob": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  var input_file_path = [].concat($job.inputs.input_file)[0].path\n  var input_file_name = input_file_path.replace(/^.*[\\\\\\/]/, '').split('.')\n  var basename = input_file_name.slice(0, -1).join('.')\n  if ($job.inputs.variants_to_keep == 'SNP')\n  {\n    ext =  '.SNPs_only'\n  }\n  else\n  {\n    ext = '.Indels_only'\n  }\n  return basename + ext + '.recode.vcf'\n}"
              },
              "sbg:inheritMetadataFrom": "#input_file",
              "secondaryFiles": [
                "*.idx"
              ]
            }
          }
        ],
        "sbg:toolkitVersion": "0.1.14",
        "inputs": [
          {
            "label": "Keep SNPs or indels?",
            "sbg:stageInput": null,
            "type": [
              {
                "symbols": [
                  "SNP",
                  "INDEL"
                ],
                "name": "variants_to_keep",
                "type": "enum"
              }
            ],
            "description": "Choose if the output file should contain only SNPs or only Indels from original file.",
            "id": "#variants_to_keep",
            "sbg:category": "Input"
          },
          {
            "label": "Input files",
            "sbg:fileTypes": "VCF",
            "type": [
              "File"
            ],
            "required": true,
            "description": "Input file.",
            "id": "#input_file",
            "inputBinding": {
              "itemSeparator": " ",
              "position": 10,
              "separate": true,
              "prefix": "--vcf",
              "sbg:cmdInclude": true
            }
          }
        ],
        "sbg:latestRevision": 2,
        "sbg:toolkit": "VCFtools",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://vcftools.github.io"
          }
        ],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "dockerImageId": "54cb823ba25a",
            "dockerPull": "images.sbgenomics.com/thedzo/vcftools:0.1.14",
            "class": "DockerRequirement"
          },
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          }
        ],
        "baseCommand": [
          "vcftools"
        ],
        "sbg:revisionNotes": "Removed index file",
        "x": -230.15151099068382,
        "sbg:modifiedBy": "ognjenm",
        "temporaryFailCodes": [],
        "sbg:toolAuthor": "Adam Auton, Petr Danecek, Anthony Marcketta",
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "VCF-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "bix-demo/vcftools-0-1-14-demo",
        "sbg:validationErrors": [],
        "sbg:sbgMaintained": false,
        "label": "VCFtools Keep SNPs or Indels",
        "successCodes": [],
        "sbg:license": "GNU General Public License version 3.0 (GPLv3)",
        "sbg:createdOn": 1472139853,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "bogdang",
        "sbg:id": "bix-demo/vcftools-0-1-14-demo/vcftools-keep-snps-or-indels/2",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "input_file": {
              "path": "/path/to/input_file.ext",
              "size": 0,
              "secondaryFiles": [
                {
                  "path": ".idx"
                }
              ],
              "class": "File"
            },
            "variants_to_keep": "INDEL"
          }
        },
        "id": "bix-demo/vcftools-0-1-14-demo/vcftools-keep-snps-or-indels/2",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1472139853,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "bogdang"
          },
          {
            "sbg:modifiedOn": 1472139865,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "bogdang"
          },
          {
            "sbg:modifiedOn": 1473168292,
            "sbg:revisionNotes": "Removed index file",
            "sbg:revision": 2,
            "sbg:modifiedBy": "ognjenm"
          }
        ],
        "sbg:cmdPreview": "vcftools --vcf /path/to/input_file.ext  --keep-only-indels  --recode --recode-INFO-all --out input_file.Indels_only",
        "sbg:projectName": "VCFtools 0.1.14 - Demo",
        "sbg:modifiedOn": 1473168292,
        "class": "CommandLineTool",
        "sbg:revision": 2,
        "sbg:contributors": [
          "ognjenm",
          "bogdang"
        ],
        "arguments": [
          {
            "position": 12,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.variants_to_keep == 'SNP')\n  {\n    return '--remove-indels'\n  }\n  else\n  {\n    return '--keep-only-indels'\n  }\n}"
            }
          },
          {
            "position": 15,
            "separate": true,
            "valueFrom": "--recode --recode-INFO-all"
          },
          {
            "position": 18,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  var input_file_path = [].concat($job.inputs.input_file)[0].path\n  var input_file_name = input_file_path.replace(/^.*[\\\\\\/]/, '').split('.')\n  var basename = input_file_name.slice(0, -1).join('.')\n  if ($job.inputs.variants_to_keep == 'SNP')\n  {\n    ext =  '.SNPs_only'\n  }\n  else\n  {\n    ext = '.Indels_only'\n  }\n  return basename + ext\n}"
            },
            "prefix": "--out"
          }
        ],
        "stdout": "",
        "description": "VCFtools Keep SNPs or Indels outputs VCF file containing only SNPs or only Indels in input VCF file.",
        "sbg:image_url": null,
        "y": 332.6018443671538,
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "engineCommand": "cwl-engine.js",
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#VCFtools_Keep_SNPs_or_Indels.variants_to_keep",
          "default": "SNP"
        },
        {
          "id": "#VCFtools_Keep_SNPs_or_Indels.input_file",
          "source": [
            "#SBG_VCF_reheader.reheaded_vcf"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#VCFtools_Keep_SNPs_or_Indels.output_file"
        }
      ],
      "sbg:x": -230.15151099068382,
      "sbg:y": 332.6018443671538,
      "scatter": "#VCFtools_Keep_SNPs_or_Indels.input_file"
    },
    {
      "id": "#SBG_VCF_reheader",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "Reheaded VCF",
            "sbg:fileTypes": "VCF",
            "type": [
              "null",
              "File"
            ],
            "description": "A VCF with changed last sample name column into the appropriate sample name.",
            "id": "#reheaded_vcf",
            "outputBinding": {
              "glob": "*.reheaded.vcf",
              "sbg:inheritMetadataFrom": "#vcf"
            }
          }
        ],
        "sbg:toolkitVersion": "v1.0",
        "inputs": [
          {
            "label": "VCF file",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "VCF",
            "type": [
              "File"
            ],
            "required": true,
            "description": "A VCF file.",
            "id": "#vcf",
            "inputBinding": {
              "position": 1,
              "separate": true,
              "prefix": "-v",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          }
        ],
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "vcf": {
              "path": "/path/to/merged.vcf",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            }
          }
        },
        "sbg:toolkit": "SBGTools",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "",
            "dockerPull": "images.sbgenomics.com/dusan_randjelovic/sci-python:2.7",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          "python",
          "vcf_parser.py"
        ],
        "sbg:toolAuthor": "Seven Bridges Genomics",
        "sbg:revisionNotes": "Rehead AF field in header from Number to '.'",
        "sbg:modifiedBy": "uros_sipetic",
        "temporaryFailCodes": [],
        "x": -456.0365699429199,
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "Other"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:validationErrors": [],
        "sbg:sbgMaintained": false,
        "label": "SBG VCF reheader",
        "successCodes": [],
        "sbg:license": "Apache License 2.0",
        "sbg:createdOn": 1477582499,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "uros_sipetic",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-vcf-reheader/3",
        "sbg:latestRevision": 3,
        "id": "bix-demo/sbgtools-demo/sbg-vcf-reheader/3",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1477582499,
            "sbg:revisionNotes": "Copy of uros_sipetic/playground/sbg-vcf-reheader/2",
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1479734228,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1485180158,
            "sbg:revisionNotes": "Sample name is derived from the VCF sample_id metadata or file name, instead of a BAM file.",
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1527005823,
            "sbg:revisionNotes": "Rehead AF field in header from Number to '.'",
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:cmdPreview": "python vcf_parser.py -v /path/to/merged.vcf -s merged -o merged.reheaded.vcf",
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:modifiedOn": 1527005823,
        "class": "CommandLineTool",
        "sbg:revision": 3,
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "arguments": [
          {
            "position": 3,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  var tmp1 = [].concat($job.inputs.vcf)[0].path.split('/').pop()\n  var str1 = tmp1.split('.')\n  var x1 = \"\"\n  for (i=0; i<str1.length-1; i++) {\n    if (i<str1.length-2) { \n    x1 = x1 + str1[i] + \".\"\n    }\n    else {\n      x1 = x1 + str1[i]\n    }\n  }\n  return x1 + \".reheaded.vcf\"\n}"
            },
            "prefix": "-o"
          },
          {
            "position": 2,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.vcf.metadata && $job.inputs.vcf.metadata.sample_id) {\n    return $job.inputs.vcf.metadata.sample_id\n  } else {\n    return $job.inputs.vcf.path.split('/').pop().split('.')[0]\n  }\n}\n"
            },
            "prefix": "-s"
          }
        ],
        "stdout": "",
        "description": "This tool changes the last column name in the VCF header to an appropriate sample name. The sample name is acquired from the input VCF sample_id metadata if available, otherwise it is acquired from the VCF file name. \n\n### Common Issues ###\nNone",
        "sbg:image_url": null,
        "y": 333.07868429031345,
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": "import argparse\n\nparser = argparse.ArgumentParser(description='This tool changes the last column name in the VCF header to an appropriate sample name. The sample name is acquired from the input vcf file sample_id metadata.')\nparser.add_argument('-v','--vcf', help='Input VCF file', required=True)\nparser.add_argument('-s','--sample_id', help='Sample ID', required=True)\nparser.add_argument('-o','--output', help='Output file',required=True)\nargs = vars(parser.parse_args())\n\nvcf_file = args['vcf']\nsampleID = args['sample_id']\noutput_file = args['output']\n\np = \"\"\nwith open(vcf_file) as f:\n    for line in f:\n\t\tif line.startswith('#CHROM'):\n\t\t\tx = line.split('\\t')\n\t\t\ttmp2 = x.pop()\n\t\t\tx.append(sampleID)\n\t\t\tp += \"\\t\".join(x) + '\\n'\n\t\telif(line.startswith('##FORMAT=<ID=AF,Number=1')):\n\t\t\tp += '##FORMAT=<ID=AF,Number=.,Type=Float,Description=\"Allele fraction of the event in the tumor\">\\n'\n\t\telse:\n\t\t\tp += line\n\t\t\tcontinue\n        \nwith open(output_file,\"w\") as f:\n    f.write(p)",
                "filename": "vcf_parser.py"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#SBG_VCF_reheader.vcf",
          "source": [
            "#VCFtools_Subset.output_file"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_VCF_reheader.reheaded_vcf"
        }
      ],
      "sbg:x": -456.0365699429199,
      "sbg:y": 333.07868429031345,
      "scatter": "#SBG_VCF_reheader.vcf"
    },
    {
      "id": "#ClonEvol_0_1",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "ClonEvol plot files",
            "sbg:fileTypes": "PDF,PNG",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "All plots outputed by ClonEvol tool.",
            "id": "#clonevol_plots",
            "outputBinding": {
              "glob": "{*.ClonEvol.output/*model.pdf,*.pdf}",
              "sbg:inheritMetadataFrom": "#input_clusters_file"
            }
          },
          {
            "label": "ClonEvol model",
            "sbg:fileTypes": "RData",
            "type": [
              "null",
              "File"
            ],
            "description": "File containing a ClonEvol model as an R object that can further be used for getting adequate plots with the Fishplot tool.",
            "id": "#clonevol_model",
            "outputBinding": {
              "glob": "*clonevol_model.RData",
              "sbg:inheritMetadataFrom": "#input_clusters_file"
            }
          }
        ],
        "sbg:toolkitVersion": "0.1",
        "inputs": [
          {
            "label": "Subclonal test method",
            "sbg:toolDefaultValue": "bootstrap",
            "id": "#subclonal_test_method",
            "description": "Subclonal test method. 'Bootstrap' perfroms bootstrap subclonal test. 'None' perfroms straight comparison of already estimated VAF for each cluster provided in 'c'.",
            "type": [
              "null",
              {
                "symbols": [
                  "bootstrap",
                  "none"
                ],
                "name": "subclonal_test_method",
                "type": "enum"
              }
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Scale cellular fraction",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "TRUE",
            "type": [
              "null",
              "boolean"
            ],
            "description": "Scale cellular fraction in the plots (ie. cell fraction will be scaled by 1/purity = 1/max(VAF*2)).",
            "id": "#scale_monoclonal_cell_frac",
            "sbg:category": "Arguments"
          },
          {
            "label": "Output format",
            "sbg:toolDefaultValue": "pdf",
            "id": "#out_format",
            "description": "Format of the plot files.",
            "type": [
              "null",
              {
                "symbols": [
                  "png",
                  "pdf",
                  "pdf.multi.files"
                ],
                "name": "out_format",
                "type": "enum"
              }
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Cancer evolution model",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "monoclonal",
            "type": [
              "null",
              {
                "symbols": [
                  "monoclonal",
                  "polyclonal"
                ],
                "name": "model",
                "type": "enum"
              }
            ],
            "description": "Cancer evolution model to use. Monoclonal model assumes the original tumor (eg. primary tumor) arises from a single normal cell; polyclonal model assumes the original tumor can arise from multiple cells (ie. multiple founding clones). In the polyclonal model, the total VAF of the separate founding clones must not exceed 0.5.",
            "id": "#model",
            "sbg:category": "Arguments"
          },
          {
            "label": "Known cancer genes database",
            "description": "Databse of known cancer genes, like COSMIC. This file is optional, and you can supply it if you want to plot clonal evolution models with variant highlight in bell plots.",
            "sbg:fileTypes": "VCF,TXT",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "sbg:altPrefix": "--cancer_genes",
            "id": "#known_cancer_genes",
            "inputBinding": {
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    return \"-c \" + $job.inputs.known_cancer_genes.path\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Clonality analysis data frame",
            "description": "Clonality analysis data frame, consisting of a 'clusters' column and columns containing VAF data for all samples that need to be analyzed. Currently ClonEvol works best if this file came from SciClone or PyClone tools.",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "TXT,CLUSTERS",
            "sbg:toolDefaultValue": "NULL",
            "id": "#input_clusters_file",
            "required": true,
            "sbg:altPrefix": "--sciclone",
            "type": [
              "File"
            ],
            "inputBinding": {
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    return \"-s \" + $job.inputs.input_clusters_file.path\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Gene annotation file",
            "description": "A GTF file containing gene annonations. This file is optional, and you can supply it if you want to plot clonal evolution models with variant highlight in bell plots.",
            "sbg:fileTypes": "GTF",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "sbg:altPrefix": "--gtf",
            "id": "#gtf",
            "inputBinding": {
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    return \"-g \" + $job.inputs.gtf.path\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "sbg:category": "Inputs"
          }
        ],
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "gtf": {
              "path": "d",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "model": "monoclonal",
            "known_cancer_genes": {
              "path": "d",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "out_format": null,
            "scale_monoclonal_cell_frac": true,
            "subclonal_test_method": null,
            "input_clusters_file": {
              "path": "/path/to/SAMPLE.clusters",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            }
          }
        },
        "sbg:toolkit": "ClonEvol",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://github.com/hdng/clonevol"
          },
          {
            "label": "Source Code",
            "id": "https://github.com/hdng/clonevol"
          },
          {
            "label": "Download",
            "id": "https://github.com/hdng/clonevol/archive/v0.1.tar.gz"
          },
          {
            "label": "Publication",
            "id": "ClonEvol: inferring and visualizing clonal evolution in multi-sample cancer sequencing (under review)"
          },
          {
            "label": "Documentation",
            "id": "https://github.com/hdng/clonevol/tree/master/man"
          }
        ],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "",
            "dockerPull": "images.sbgenomics.com/uros_sipetic/clonevol:0.1",
            "class": "DockerRequirement"
          },
          {
            "value": "ClonEvol.R",
            "class": "sbg:SaveLogs"
          }
        ],
        "baseCommand": [
          {
            "engine": "#cwl-js-engine",
            "class": "Expression",
            "script": "{\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    return \"python add_known_cancer_genes.py\"\n  }\n}"
          }
        ],
        "sbg:revisionNotes": "Add ClonEvol.R as savelogs",
        "x": 1595.9476587803517,
        "sbg:modifiedBy": "uros_sipetic",
        "temporaryFailCodes": [],
        "sbg:toolAuthor": "Ha X. Dang, Brian S. White, Steven M. Foltz, Christopher A. Miller, Jingqin Luo, Ryan C. Fields, Christopher A. Maher",
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "Tumor-heterogeneity",
          "Sub-clonality",
          "Cancer"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "uros_sipetic/clonevol-0-1",
        "sbg:validationErrors": [],
        "sbg:sbgMaintained": false,
        "label": "ClonEvol 0.1",
        "successCodes": [
          1,
          0
        ],
        "sbg:license": "GNU General Public License v3.0 only",
        "sbg:createdOn": 1468512646,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "uros_sipetic",
        "sbg:id": "uros_sipetic/clonevol-0-1/clonevol-0-1/68",
        "sbg:latestRevision": 68,
        "id": "uros_sipetic/clonevol-0-1/clonevol-0-1/68",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1468512646,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468513154,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468576757,
            "sbg:revisionNotes": null,
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468590965,
            "sbg:revisionNotes": null,
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468591378,
            "sbg:revisionNotes": null,
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468930349,
            "sbg:revisionNotes": null,
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468932199,
            "sbg:revisionNotes": null,
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468939798,
            "sbg:revisionNotes": null,
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468946425,
            "sbg:revisionNotes": null,
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1468949211,
            "sbg:revisionNotes": null,
            "sbg:revision": 9,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1469008442,
            "sbg:revisionNotes": null,
            "sbg:revision": 10,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1469015549,
            "sbg:revisionNotes": null,
            "sbg:revision": 11,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471266088,
            "sbg:revisionNotes": null,
            "sbg:revision": 12,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471266285,
            "sbg:revisionNotes": null,
            "sbg:revision": 13,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471268455,
            "sbg:revisionNotes": "Added the recommended fix when only one sample is provided.",
            "sbg:revision": 14,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471268571,
            "sbg:revisionNotes": null,
            "sbg:revision": 15,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471268604,
            "sbg:revisionNotes": null,
            "sbg:revision": 16,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471268826,
            "sbg:revisionNotes": null,
            "sbg:revision": 17,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471269942,
            "sbg:revisionNotes": null,
            "sbg:revision": 18,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471270568,
            "sbg:revisionNotes": null,
            "sbg:revision": 19,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471272253,
            "sbg:revisionNotes": null,
            "sbg:revision": 20,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471275048,
            "sbg:revisionNotes": null,
            "sbg:revision": 21,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471276068,
            "sbg:revisionNotes": null,
            "sbg:revision": 22,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471277068,
            "sbg:revisionNotes": null,
            "sbg:revision": 23,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471351030,
            "sbg:revisionNotes": null,
            "sbg:revision": 24,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471361518,
            "sbg:revisionNotes": null,
            "sbg:revision": 25,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471361994,
            "sbg:revisionNotes": null,
            "sbg:revision": 26,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471362553,
            "sbg:revisionNotes": null,
            "sbg:revision": 27,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471362846,
            "sbg:revisionNotes": null,
            "sbg:revision": 28,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471363214,
            "sbg:revisionNotes": null,
            "sbg:revision": 29,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471366284,
            "sbg:revisionNotes": null,
            "sbg:revision": 30,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471366334,
            "sbg:revisionNotes": null,
            "sbg:revision": 31,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471366686,
            "sbg:revisionNotes": null,
            "sbg:revision": 32,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471367282,
            "sbg:revisionNotes": null,
            "sbg:revision": 33,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1471368170,
            "sbg:revisionNotes": null,
            "sbg:revision": 34,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472562374,
            "sbg:revisionNotes": null,
            "sbg:revision": 35,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472562831,
            "sbg:revisionNotes": null,
            "sbg:revision": 36,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472562896,
            "sbg:revisionNotes": null,
            "sbg:revision": 37,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472568087,
            "sbg:revisionNotes": null,
            "sbg:revision": 38,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472568175,
            "sbg:revisionNotes": null,
            "sbg:revision": 39,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472634413,
            "sbg:revisionNotes": null,
            "sbg:revision": 40,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472637716,
            "sbg:revisionNotes": null,
            "sbg:revision": 41,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472647534,
            "sbg:revisionNotes": null,
            "sbg:revision": 42,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1473505933,
            "sbg:revisionNotes": null,
            "sbg:revision": 43,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1473932253,
            "sbg:revisionNotes": null,
            "sbg:revision": 44,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1473945323,
            "sbg:revisionNotes": null,
            "sbg:revision": 45,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476875143,
            "sbg:revisionNotes": null,
            "sbg:revision": 46,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476877000,
            "sbg:revisionNotes": null,
            "sbg:revision": 47,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476877049,
            "sbg:revisionNotes": null,
            "sbg:revision": 48,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476877617,
            "sbg:revisionNotes": null,
            "sbg:revision": 49,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476877761,
            "sbg:revisionNotes": null,
            "sbg:revision": 50,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476878808,
            "sbg:revisionNotes": null,
            "sbg:revision": 51,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476879445,
            "sbg:revisionNotes": null,
            "sbg:revision": 52,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476881063,
            "sbg:revisionNotes": null,
            "sbg:revision": 53,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1476957786,
            "sbg:revisionNotes": null,
            "sbg:revision": 54,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1477497724,
            "sbg:revisionNotes": null,
            "sbg:revision": 55,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1477500623,
            "sbg:revisionNotes": null,
            "sbg:revision": 56,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1477503239,
            "sbg:revisionNotes": null,
            "sbg:revision": 57,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1477996760,
            "sbg:revisionNotes": null,
            "sbg:revision": 58,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1480076302,
            "sbg:revisionNotes": null,
            "sbg:revision": 59,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498501897,
            "sbg:revisionNotes": null,
            "sbg:revision": 60,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498504110,
            "sbg:revisionNotes": null,
            "sbg:revision": 61,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1499271147,
            "sbg:revisionNotes": "Add metadata inheritance.",
            "sbg:revision": 62,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1501767484,
            "sbg:revisionNotes": "Update a renaming expression.",
            "sbg:revision": 63,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1509560352,
            "sbg:revisionNotes": "Update output names",
            "sbg:revision": 64,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1511311102,
            "sbg:revisionNotes": "Remove trimmed.trees output.",
            "sbg:revision": 65,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1511314874,
            "sbg:revisionNotes": "Update glob.",
            "sbg:revision": 66,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1526891551,
            "sbg:revisionNotes": "Rework the R code for detecting multiple samples",
            "sbg:revision": 67,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1527002935,
            "sbg:revisionNotes": "Add ClonEvol.R as savelogs",
            "sbg:revision": 68,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:cmdPreview": "python add_known_cancer_genes.py  -s /path/to/SAMPLE.clusters  && Rscript ClonEvol.R  && mv SAMPLE.ClonEvol.output/model.pdf SAMPLE.ClonEvol.output/SAMPLE.clonevol_model.pdf  && if [ -a SAMPLE.ClonEvol.output/model.trimmed-trees.pdf ]; then rm SAMPLE.ClonEvol.output/model.trimmed-trees.pdf; fi",
        "sbg:projectName": "ClonEvol 0.1 - Demo",
        "sbg:modifiedOn": 1527002935,
        "class": "CommandLineTool",
        "sbg:revision": 68,
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "arguments": [
          {
            "position": 99,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    return \"&& Rscript ClonEvol.R\"\n  } else {\n    return \"Rscript ClonEvol.R\"\n  }\n}"
            }
          },
          {
            "position": 100,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  var x = $job.inputs.input_clusters_file\n  var y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  var z = y + \".ClonEvol.output\"\n  \n  return \"&& mv \" + z + \"/model.pdf \" + z + \"/\" + y + \".clonevol_model.pdf\"\n}"
            }
          },
          {
            "position": 101,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  var x = $job.inputs.input_clusters_file\n  var y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  var z = y + \".ClonEvol.output\"\n  var COMMAND = \"&& if [ -a \" + z + \"/model.trimmed-trees.pdf ]; \"\n  COMMAND += \"then rm \" + z + \"/model.trimmed-trees.pdf; \" \n  COMMAND += \"fi\"\n  return COMMAND\n}"
            }
          }
        ],
        "stdout": "",
        "description": "ClonEvol is used for inferring and visualizing clonal evolution in multi-sample cancer sequencing. \n\nClonEvol infers clonal evolution models in single sample or multiple samples using the clusters of variants identified previously using other methods such as sciClone or PyClone. Variant clusters must be biologically interpretable for ClonEvol to be able to infer some models. Most of the time you will find yourself iteratively refining the clustering of the variants and running ClonEvol, until some reasonable models are found.\n\nClonEvol can infer clonal structures end evolution models for multi cancer samles from a single patient (eg primary tumors, metastatic tumors, xenograft tumors, multi-region samples, etc.).\n\n### Common Issues ###\nCurrently, ClonEvol works well using SciClone results as input files.",
        "sbg:image_url": null,
        "y": 323.22819118331614,
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": {
                  "engine": "#cwl-js-engine",
                  "class": "Expression",
                  "script": "{\n  var COMMAND = \"library(clonevol)\\n\"\n  z = \"library(ggplot2)\\n\"\n  z += \"options(expressions=10000)\\n\"\n  COMMAND += z\n  \n  var TAG = false\n  if ($job.inputs.known_cancer_genes && $job.inputs.gtf) {\n    var TAG = true\n  }\n  \n  //load data\n  if (TAG) {\n    y = 'sciclone_clusters_parsed'\n  } else {\n    x = $job.inputs.input_clusters_file\n    y = x.path.split('/').pop()\n  }\n  z = \"data = read.table('\" + y + \"',header=T)\\n\"\n  z += \"data = data[!is.na(data$cluster),]\\n\"\n  z += \"vaf.col.names <- grep('.vaf', colnames(data), value=TRUE, fixed=TRUE)\\n\"\n  COMMAND += z\n  \n  //infer clonal evolution models\n  z = \"x <- infer.clonal.models(variants=data,\\n\\\n\t\t   cluster.col.name='cluster',\\n\\\n\t\t   vaf.col.names=vaf.col.names,\\n\\\n\t\t   subclonal.test.model='non-parametric',\\n\\\n\t\t   cluster.center='mean',\\n\\\n\t\t   num.boots=1000,\\n\\\n\t\t   founding.cluster=1,\\n\\\n\t\t   min.cluster.vaf=0.01,\\n\\\n\t\t   p.value.cutoff=0.01,\\n\\\n\t\t   alpha=0.1,\\n\\\n\t\t   random.seed=63108\"\n  if ($job.inputs.subclonal_test_method) {\n    x = $job.inputs.subclonal_test_method\n    z += \",\\n\\\n\t\t   subclonal.test='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\t\t   subclonal.test='bootstrap'\"\n  }\n  if ($job.inputs.model) {\n    x = $job.inputs.model\n    z += \",\\n\\\n\t\t   model='\" + x + \"')\\n\"\n  } else {\n    z += \")\\n\"\n  }\n  COMMAND += z\n  \n  //plot clonal evolution models\n  x = $job.inputs.input_clusters_file\n  y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  z = \"plot.clonal.models(x$models,\\n\\\n\t\t   matched=x$matched,\\n\\\n\t\t   variants=data,\\n\\\n\t\t   clone.shape='bell',\\n\\\n\t\t   box.plot=TRUE,\\n\\\n\t\t   overwrite.output=TRUE,\\n\\\n\t\t   cell.frac.ci=TRUE,\\n\\\n\t\t   tree.node.shape='circle',\\n\\\n\t\t   tree.node.size=40,\\n\\\n\t\t   tree.node.text.size=0.65,\\n\\\n\t\t   out.dir='\" + y + \".ClonEvol.output'\"\n  if ($job.inputs.scale_monoclonal_cell_frac) {\n    x = $job.inputs.scale_monoclonal_cell_frac\n    z += \",\\n\\\n\t\t   scale.monoclonal.cell.frac=\" + String(x).toUpperCase()\n  }\n  if ($job.inputs.out_format) {\n    x = $job.inputs.out_format\n    z += \",\\n\\\n\t\t   out.format='\" + x + \"')\\n\"\n  } else {\n    z += \",\\n\\\n\t\t   out.format='pdf')\\n\"\n  }\n  COMMAND += z\n  \n  if (TAG) {\n  //plot clonal evolution models (with variant highlight in bell plots)\n  x = $job.inputs.input_clusters_file\n  y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  z = \"var.to.highlight = data[data$is.cancer.gene, c('cluster', 'gene')]\\n\"\n  z += \"colnames(var.to.highlight) = c('cluster', 'variant.name')\\n\"\n  COMMAND += z\n  z = \"plot.clonal.models(x$models,\\n\\\n\t\t   matched=x$matched,\\n\\\n\t\t   variants=data,\\n\\\n\t\t   clone.shape='bell',\\n\\\n\t\t   box.plot=TRUE,\\n\\\n\t\t   overwrite.output=TRUE,\\n\\\n\t\t   cell.frac.ci=TRUE,\\n\\\n\t\t   variants.to.highlight=var.to.highlight,\\n\\\n \t\t   variant.color='blue',\\n\\\n \t\t   variant.angle=60,\\n\\\n\t\t   tree.node.shape='circle',\\n\\\n\t\t   tree.node.size=40,\\n\\\n\t\t   tree.node.text.size=0.65,\\n\\\n\t\t   out.dir='\" + y + \".bell.ClonEval.output'\"\n  if ($job.inputs.scale_monoclonal_cell_frac) {\n    x = $job.inputs.scale_monoclonal_cell_frac\n    z += \",\\n\\\n\t\t   scale.monoclonal.cell.frac=\" + String(x).toUpperCase()\n  }\n  if ($job.inputs.out_format) {\n    x = $job.inputs.out_format\n    z += \",\\n\\\n\t\t   out.format='\" + x + \"')\\n\"\n  } else {\n    z += \")\\n\"\n  }\n  COMMAND += z\n\n  //plot box/violin/jitter of VAFs with cancer gene variants highlighted\n  x = $job.inputs.input_clusters_file\n  y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  z = \"num.clusters <- length(unique(data$cluster))\\n\"\n  z += \"pdf('\" + y + \".variants.jitter.pdf', width=5, height=5, useDingbats=FALSE)\\n\"\n  COMMAND += z\n  \n  z = \"pp = variant.box.plot(data,\\n\\\n\t\t   vaf.col.names=vaf.col.names,\\n\\\n\t\t   variant.class.col.name=NULL,\\n\\\n\t\t   cluster.axis.name='',\\n\\\n\t\t   vaf.limits=70,\\n\\\n\t\t   violin=FALSE,\\n\\\n\t\t   box=FALSE,\\n\\\n\t\t   order.by.total.vaf=FALSE,\\n\\\n\t\t   jitter=TRUE,\\n\\\n\t\t   jitter.center.method='mean',\\n\\\n\t\t   jitter.center.size=0.5,\\n\\\n\t\t   jitter.center.color='darkgray',\\n\\\n\t\t   jitter.shape=1,\\n\\\n\t\t   jitter.color=get.clonevol.colors(num.clusters),\\n\\\n\t\t   jitter.size=2,\\n\\\n\t\t   jitter.alpha=1,\\n\\\n\t\t   highlight='is.cancer.gene',\\n\\\n\t\t   highlight.note.col.name='gene',\\n\\\n\t\t   highlight.shape=19,\\n\\\n\t\t   display.plot=TRUE)\\n\"\n  z += \"dev.off()\\n\"\n  COMMAND += z\n  }\n  \n  //plot pairwise VAFs across samples\n  x = $job.inputs.input_clusters_file\n  y = x.path.split('/').pop().split('.').slice(0,-1).join('.')\n  z = \"num.clusters <- length(unique(data$cluster))\\n\"\n  z += \"if (length(vaf.col.names)>1) {\\n\" \n  z += \"plot.pairwise(data, col.names=vaf.col.names,\\n\\\n\t\t   out.prefix='\" + y + \".variants.pairwise.plot',\\n\\\n\t\t   colors=get.clonevol.colors(num.clusters))\\n}\\n\"\n  COMMAND += z\n  \n  //plot mean/median of clusters across samples (cluster flow)\n  z = \"s1 = gsub('.{4}$', '', vaf.col.names)\\n\"\n  COMMAND += z\n  z = \"plot.cluster.flow(data, vaf.col.names=vaf.col.names,\\n\\\n\t\t   out.file='\" + y + \".flow.pdf',\\n\\\n\t\t   colors=get.clonevol.colors(num.clusters),\\n\\\n\t\t   sample.names=s1)\\n\"\n  COMMAND += z\n  \n  //if only one sample - copy the sample to make fishplot work\n  z = \"if (length(vaf.col.names)==1) {\\n\" \n  z += \"data[,paste0(vaf.col.names,'2')] = data[,vaf.col.names]\\n\\\nvaf.col.names = c(vaf.col.names, paste0(vaf.col.names,'2'))\\n\\\ns1 = gsub('.{4}$', '', vaf.col.names)\\n\"\n  z += \"x <- infer.clonal.models(variants=data,\\n\\\n\t\t   cluster.col.name='cluster',\\n\\\n\t\t   vaf.col.names=vaf.col.names,\\n\\\n\t\t   subclonal.test.model='non-parametric',\\n\\\n\t\t   cluster.center='mean',\\n\\\n\t\t   num.boots=1000,\\n\\\n\t\t   founding.cluster=1,\\n\\\n\t\t   min.cluster.vaf=0.01,\\n\\\n\t\t   p.value.cutoff=0.01,\\n\\\n\t\t   alpha=0.1,\\n\\\n\t\t   random.seed=63108\"\n  if ($job.inputs.subclonal_test_method) {\n    x = $job.inputs.subclonal_test_method\n    z += \",\\n\\\n\t\t   subclonal.test='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\t\t   subclonal.test='bootstrap'\"\n  }\n  if ($job.inputs.model) {\n    x = $job.inputs.model\n    z += \",\\n\\\n\t\t   model='\" + x + \"')\\n\"\n  } else {\n    z += \")\\n\"\n  }\n  z += \"}\\n\"\n\n  COMMAND += z\n  \n  //save variables x and s1 as R object for further use (Fishplot)\n  z = \"save(x, s1, file='\" + y + \".clonevol_model.RData')\\n\"\n  COMMAND += z\n  \n  //return whole script\n  return COMMAND\n}\n  \n  "
                },
                "filename": "ClonEvol.R"
              },
              {
                "fileContent": "import argparse\n\nparser = argparse.ArgumentParser(description='This script adds a \"gene\" and \"is.cancer.gene\" columns to the SciClone \"clusters\" output file.')\nparser.add_argument('-s','--sciclone', help='Input SciClone \"clusters\" file.', required=True)\nparser.add_argument('-g','--gtf', help='Input GTF file.', required=True)\nparser.add_argument('-c','--cancer_genes', help='Databse of known cancer genes, like COSMIC.', required=True)\nargs = vars(parser.parse_args())\n\nsciclone_file = args['sciclone']\ngtf_file = args['gtf']\ncancer_genes_file = args['cancer_genes']\n\nwith open(gtf_file, 'r') as gtf_content_file:\n    gtf_content = gtf_content_file.read()\nwith open(cancer_genes_file, 'r') as cancer_content_file:\n    cancer_content = cancer_content_file.read()\nwith open(sciclone_file, 'r') as sciclone_content_file:\n    sciclone_content = sciclone_content_file.read()\n\n\ngtf_lines = gtf_content.split('\\n')\ngtf_lines.pop()\ngtf_fields = [];\nfor tmp_fields in gtf_lines:\n    if tmp_fields[0]=='#':\n        continue\n    tmp_splited = tmp_fields.split('\\t')\n    if tmp_splited[2]=='gene':\n        tmp_list = [];\n        tmp_list.append(tmp_splited[0])\n        tmp_list.append(tmp_splited[3])\n        tmp_list.append(tmp_splited[4])\n        details_splited = tmp_splited[-1].split(';')\n        for tmp_details in details_splited:\n            if tmp_details[1:10] == 'gene_name':\n                tmp_list.append(tmp_details[12:-1])\n                break\n        gtf_fields.append(tmp_list)\n    \ncancer_lines = cancer_content.split('\\n')\ncancer_lines.pop()\ncancer_fields = [];\nfor tmp_fields in cancer_lines:\n    if tmp_fields[0]=='#':\n        continue\n    tmp_splited = tmp_fields.split('\\t')\n    \n    tmp_list = [];\n    tmp_list.append(tmp_splited[0])\n    tmp_list.append(tmp_splited[1])\n    cancer_fields.append(tmp_list)\n\n\nsciclone_lines = sciclone_content.split('\\n')\nsciclone_lines.pop()\n\np = ''\nfor line in sciclone_lines:\n    if line[0:4]=='chr\\t':\n        p += line + '\\t' + 'gene' + '\\t' + 'is.cancer.gene' + '\\n'\n        continue\n    x = line.split('\\t')\n    if line[0:3]=='chr':\n        chr_number = x[0][3:len(x)+1]\n    else:\n        chr_number = x[0]\n    \n    position = int(x[1])\n    \n    found_gene = False\n    for gtf_line in gtf_fields:\n        if gtf_line[0][0:3]=='chr':\n            gtf_chr_number = gtf_line[0][3:len(gtf_line)+1]\n        else:\n            gtf_chr_number = gtf_line[0]\n                \n        if ((chr_number == gtf_chr_number) and (int(gtf_line[1]) <= position) and (int(gtf_line[2]) >= position)):\n            found_gene = True            \n            ind = False            \n            for cancer_line in cancer_fields:\n                if cancer_line[0:3]=='chr':\n                    cancer_chr_number = cancer_line[0][3:len(cancer_line)+1]\n                else:\n                    cancer_chr_number = cancer_line[0]   \n                if(cancer_chr_number == chr_number) and (int(gtf_line[1]) <= int(cancer_line[1])) and (int(gtf_line[2]) >= int(cancer_line[1])):\n                    ind = True\n                if ind:\n                    p+= line + '\\t' + gtf_line[-1] + '\\t' + 'TRUE\\n'\n                    break\n                \n            if ind==False:                    \n                p+= line + '\\t' + gtf_line[-1] + '\\t' + 'FALSE\\n'\n                \n            break\n    if found_gene == False:\n        p+= line + '\\t' + 'NA' + '\\t' + 'FALSE\\n'\n    \nwith open('sciclone_clusters_parsed', \"w\") as f:\n    f.write(p)",
                "filename": "add_known_cancer_genes.py"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#ClonEvol_0_1.subclonal_test_method"
        },
        {
          "id": "#ClonEvol_0_1.scale_monoclonal_cell_frac"
        },
        {
          "id": "#ClonEvol_0_1.out_format"
        },
        {
          "id": "#ClonEvol_0_1.model"
        },
        {
          "id": "#ClonEvol_0_1.known_cancer_genes",
          "source": [
            "#known_cancer_genes"
          ]
        },
        {
          "id": "#ClonEvol_0_1.input_clusters_file",
          "source": [
            "#SciClone_1_1.clusters"
          ]
        },
        {
          "id": "#ClonEvol_0_1.gtf",
          "source": [
            "#gtf"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#ClonEvol_0_1.clonevol_plots"
        },
        {
          "id": "#ClonEvol_0_1.clonevol_model"
        }
      ],
      "sbg:x": 1595.9476587803517,
      "sbg:y": 323.22819118331614
    },
    {
      "id": "#Fishplot_0_3",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "Plotting Log",
            "sbg:fileTypes": "LOG",
            "type": [
              "null",
              "File"
            ],
            "description": "Log file to catch errors in case no output is made.",
            "id": "#plotting_log",
            "outputBinding": {
              "glob": "*fishplot.log",
              "sbg:inheritMetadataFrom": "#input_file"
            }
          },
          {
            "label": "Fishplot output",
            "sbg:fileTypes": "PDF",
            "type": [
              "null",
              "File"
            ],
            "description": "PDF file produced by the Fishplot tool.",
            "id": "#fishplot_plots",
            "outputBinding": {
              "glob": "*.pdf",
              "sbg:inheritMetadataFrom": "#input_file"
            }
          },
          {
            "label": "Clonal evolution models",
            "sbg:fileTypes": "TXT",
            "type": [
              "null",
              "File"
            ],
            "description": "Clonal evolution models, as plotted in the PDF output. Each line represent a separate model, and can be interpreted as follow: the order of numbers corresponds to the number of subclone, while the value indicates the parent from which the subclone arose.",
            "id": "#clonal_evolution_models",
            "outputBinding": {
              "glob": "*.clonal_evolution_models.txt",
              "sbg:inheritMetadataFrom": "#input_file"
            }
          }
        ],
        "sbg:toolkitVersion": "0.3",
        "inputs": [
          {
            "label": "Bottom title",
            "sbg:toolDefaultValue": "NULL",
            "id": "#title_btm",
            "description": "A string for the title at the bottom left, internal to the plot.",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Title",
            "sbg:toolDefaultValue": "NULL",
            "id": "#title",
            "description": "A string for the title above the plot.",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Shape",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "spline",
            "type": [
              "null",
              {
                "symbols": [
                  "spline",
                  "polygon",
                  "bezier"
                ],
                "name": "shape",
                "type": "enum"
              }
            ],
            "description": "The type of shape to construct the plot out of. The \"spline\" and \"polygon\" methods work well. \"Bezier\" is more hit or miss.",
            "id": "#shape",
            "sbg:category": "Arguments"
          },
          {
            "label": "Ramp angle",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0.5",
            "type": [
              "null",
              "float"
            ],
            "description": "{A numeric value between 0 and 1 that indicates how steeply the shape should expand from it's leftmost origin to the first measured point. Only used when shape=\"polygon\".",
            "id": "#ramp_angle",
            "sbg:category": "Arguments"
          },
          {
            "label": "Left padding",
            "sbg:toolDefaultValue": "0.5",
            "id": "#pad_left",
            "description": "The amount of \"ramp-up\" to the left of the first timepoint. Given as a fraction of the total plot width.",
            "type": [
              "null",
              "float"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "ClonEvol RData file",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "RDATA",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "RData file outputed by ClonEvol, containing an R object with the proper ClonEvol model, to be used for plotting by Fishplot.",
            "id": "#input_file",
            "sbg:category": "Arguments"
          },
          {
            "label": "Vertical line color",
            "sbg:toolDefaultValue": "#FFFFFF99",
            "id": "#col_vline",
            "description": "Color value for the vertical lines.",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Border color",
            "sbg:toolDefaultValue": "#777777",
            "id": "#col_border",
            "description": "A color for the border line.",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Top lable size scaling",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0.7",
            "type": [
              "null",
              "float"
            ],
            "description": "A numeric value for scaling the top label size.",
            "id": "#cex_vlab",
            "sbg:category": "Arguments"
          },
          {
            "label": "Title size scaling",
            "sbg:toolDefaultValue": "0.5",
            "id": "#cex_title",
            "description": "A numeric value for scaling the title size.",
            "type": [
              "null",
              "float"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Border width",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0.5",
            "type": [
              "null",
              "float"
            ],
            "description": "A numeric width for the border line around this polygon.",
            "id": "#border",
            "sbg:category": "Arguments"
          }
        ],
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "ramp_angle": null,
            "col_border": "",
            "col_vline": "",
            "pad_left": null,
            "border": null,
            "input_file": {
              "path": "/path/to/NORMAL.TUMOR1.TUMOR2.STRELKA.clonevol_model.rdata",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "title_btm": "",
            "title": "",
            "cex_title": null,
            "shape": "spline",
            "cex_vlab": null
          }
        },
        "sbg:toolkit": "Fishplot",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://github.com/chrisamiller/fishplot"
          },
          {
            "label": "Source Code",
            "id": "https://github.com/chrisamiller/fishplot"
          },
          {
            "label": "Download",
            "id": "https://github.com/chrisamiller/fishplot/archive/v0.3.tar.gz"
          },
          {
            "label": "Publication",
            "id": "http://biorxiv.org/content/biorxiv/early/2016/06/15/059055.full.pdf"
          },
          {
            "label": "Documentation",
            "id": "https://github.com/chrisamiller/fishplot/tree/master/man"
          }
        ],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "",
            "dockerPull": "images.sbgenomics.com/uros_sipetic/fishplot:0.3",
            "class": "DockerRequirement"
          },
          {
            "value": "Fishplot.R",
            "class": "sbg:SaveLogs"
          }
        ],
        "baseCommand": [
          {
            "engine": "#cwl-js-engine",
            "class": "Expression",
            "script": "{\n  if ($job.inputs.input_file) {\n    return \"Rscript --vanilla Fishplot.R\"\n  } else {\n    return \"echo ClonEvol data frame is empty, skipping plotting. \"\n  }\n}"
          }
        ],
        "sbg:revisionNotes": "Fix some unimportant javascript expression.",
        "x": 1815.7201276506703,
        "sbg:modifiedBy": "uros_sipetic",
        "temporaryFailCodes": [],
        "sbg:toolAuthor": "Christopher A. Miller, Joshua McMichael, Ha X. Dang, Christopher A. Maher, Li Ding, Timothy J . Ley, Elaine R. Mardis, Richard K. Wilson",
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "Tumor-heterogeneity",
          "Sub-clonality"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "uros_sipetic/fishplot-0-3",
        "sbg:validationErrors": [],
        "sbg:sbgMaintained": false,
        "label": "Fishplot 0.3",
        "successCodes": [
          1,
          0
        ],
        "sbg:license": "Apache License 2.0",
        "sbg:createdOn": 1472570110,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "uros_sipetic",
        "sbg:id": "uros_sipetic/fishplot-0-3/fishplot-0-3/30",
        "sbg:latestRevision": 30,
        "id": "uros_sipetic/fishplot-0-3/fishplot-0-3/30",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1472570110,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472571962,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472573615,
            "sbg:revisionNotes": null,
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472577240,
            "sbg:revisionNotes": null,
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472577466,
            "sbg:revisionNotes": null,
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472577557,
            "sbg:revisionNotes": null,
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472577836,
            "sbg:revisionNotes": null,
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472578136,
            "sbg:revisionNotes": null,
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472634711,
            "sbg:revisionNotes": null,
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472637454,
            "sbg:revisionNotes": null,
            "sbg:revision": 9,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472637640,
            "sbg:revisionNotes": null,
            "sbg:revision": 10,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472639720,
            "sbg:revisionNotes": null,
            "sbg:revision": 11,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472640669,
            "sbg:revisionNotes": null,
            "sbg:revision": 12,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472645237,
            "sbg:revisionNotes": null,
            "sbg:revision": 13,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1472647269,
            "sbg:revisionNotes": null,
            "sbg:revision": 14,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1473264486,
            "sbg:revisionNotes": null,
            "sbg:revision": 15,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1478942195,
            "sbg:revisionNotes": "error handling from ClonEvol",
            "sbg:revision": 16,
            "sbg:modifiedBy": "dusan_randjelovic"
          },
          {
            "sbg:modifiedOn": 1478952720,
            "sbg:revisionNotes": "Error handling, escape from fn",
            "sbg:revision": 17,
            "sbg:modifiedBy": "dusan_randjelovic"
          },
          {
            "sbg:modifiedOn": 1478953383,
            "sbg:revisionNotes": "Added output log to collect stdout",
            "sbg:revision": 18,
            "sbg:modifiedBy": "dusan_randjelovic"
          },
          {
            "sbg:modifiedOn": 1479810236,
            "sbg:revisionNotes": null,
            "sbg:revision": 19,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1479837659,
            "sbg:revisionNotes": null,
            "sbg:revision": 20,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1493228230,
            "sbg:revisionNotes": null,
            "sbg:revision": 21,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1493287459,
            "sbg:revisionNotes": null,
            "sbg:revision": 22,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498502794,
            "sbg:revisionNotes": null,
            "sbg:revision": 23,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498503939,
            "sbg:revisionNotes": null,
            "sbg:revision": 24,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498504789,
            "sbg:revisionNotes": null,
            "sbg:revision": 25,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1498505046,
            "sbg:revisionNotes": null,
            "sbg:revision": 26,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1509564162,
            "sbg:revisionNotes": null,
            "sbg:revision": 27,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1518542419,
            "sbg:revisionNotes": "Add a text output with clonal evolution models.",
            "sbg:revision": 28,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1518555512,
            "sbg:revisionNotes": "Update clonal evolution model txt output bug",
            "sbg:revision": 29,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1527009596,
            "sbg:revisionNotes": "Fix some unimportant javascript expression.",
            "sbg:revision": 30,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:cmdPreview": "Rscript --vanilla Fishplot.R  > NORMAL.TUMOR1.TUMOR2.STRELKA.fishplot.log",
        "sbg:projectName": "Fishplot 0.3 - Demo",
        "sbg:modifiedOn": 1527009596,
        "class": "CommandLineTool",
        "sbg:revision": 30,
        "sbg:contributors": [
          "uros_sipetic",
          "dusan_randjelovic"
        ],
        "arguments": [],
        "stdout": {
          "engine": "#cwl-js-engine",
          "class": "Expression",
          "script": "{\n  if ($job.inputs.input_file) {\n  \tvar x = [].concat($job.inputs.input_file)[0].path.split('/').pop().split('.').slice(0,-2).join('.')\n  \treturn x + '.fishplot.log'\n  }\n}"
        },
        "description": "Massively parallel sequencing at depth is now enabling tumor heterogeneity and evolution to be characterized in unprecedented detail. Tracking these changes in clonal architecture often provides insight into therapeutic response and resistance. Easily interpretable data visualizations can greatly aid these  studies, especially in cases with multiple timepoints. Current data visualization methods are typically manual and laborious, and often only approximate subclonal fractions. \n\nFishplot is an R package that accurately and intuitively displays changes in clonal structure over time. It requires simple input data and produces illustrative and easy-to-interpret graphs suitable for diagnosis, presentation, and publication.\n\n### Common Issues ###\nCurrently, Fishplot works well using ClonEvol model output as an input file.",
        "sbg:image_url": null,
        "y": 315.80326625279025,
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": {
                  "engine": "#cwl-js-engine",
                  "class": "Expression",
                  "script": "{\n  var COMMAND = \"library(fishplot)\\n\"\n  var z = \"library(clonevol)\\n\"\n  COMMAND += z\n  \n  //generate phylogeny with clonevol\n  tmp1 = $job.inputs.input_file\n  if (tmp1) {\n    tmp2 = tmp1.path.split('/').pop()\n  } else {\n    tmp2 = 'dummy_data_frame'\n  }\n  z = \"fishplot <- function(){\\n\\n\\\nload('\" + tmp2 + \"')\\n\\n\"\n  COMMAND += z\n  \n  // catch exceptions from ClonEvol\n  null_models = 'if (is.null(x$matched$index)){\\n\\\n  return(\"NULL models\")\\n\\\n}\\n'\n  COMMAND += null_models\n\n  no_subclones = 'subclones_per_sample <- sapply(x$models, function(samp) nrow(samp[[1]]))\\n\\\nif (1 %in% subclones_per_sample){\\n\\\n  no_subclones <- grepl(1, subclones_per_sample)\\n\\\n  return(paste0(\"NO subclones in samples: \", names(subclones_per_sample[no_subclones])))\\n\\\n}\\n\\n'\n  COMMAND += no_subclones\n  \n  //create a list of fish objects \n  z = \"f = generateFishplotInputs(results=x)\\n\"\n  z += \"fishes = createFishPlotObjects(f)\\n\"\n  COMMAND += z\n  \n  //create empty matrix for writting results to a file later\n  z = \"mat = matrix(0,length(fishes),length(fishes[[1]]@parents))\\n\"\n  COMMAND += z\n  \n  //plot with fishplot\n  tmp3 = tmp2.split('.')\n  tmp4 = tmp3.slice(0,-2).join('.')\n  z = \"pdf('\" + tmp4 + \".fishplot.pdf', width=8, height=5)\\n\"\n  z += \"for (i in 1:length(fishes)){\\n\\\n\tmat[i,] = fishes[[i]]@parents\\n\\\n\tfish = layoutClones(fishes[[i]])\\n\\\n\tfish = setCol(fish,f$clonevol.clone.colors)\\n\"\n  COMMAND += z\n  \n  z = \"\\tfishPlot(fish,\\n\\\n\tvlines=seq(1, length(s1)),\\n\\\n\tvlab=s1\"\n    \n  if ($job.inputs.shape) {\n    x = $job.inputs.shape\n    z += \",\\n\\\n\tshape='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\tshape='spline'\"\n  }\n  \n  if ($job.inputs.title_btm) {\n    x = $job.inputs.title_btm\n    z += \",\\n\\\n\ttitle.btm='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\ttitle.btm='\" + tmp4 + \"'\"\n  }\n\n  if ($job.inputs.cex_title) {\n    x = $job.inputs.cex_title\n    z += \",\\n\\\n\tcex.title=\" + x\n  } else {\n    z += \",\\n\\\n\tcex.title=0.5\"\n  }\n  \n  if ($job.inputs.pad_left) {\n    x = $job.inputs.pad_left\n    z += \",\\n\\\n\tpad.left=\" + x\n  } else {\n    z += \",\\n\\\n\tpad.left=0.5\"\n  }\n  \n  if ($job.inputs.col_vline) {\n    x = $job.inputs.col_vline\n    z += \",\\n\\\n\tcol.vline='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\tcol.vline='#FFFFFF99'\"\n  }\n  \n  if ($job.inputs.border) {\n    x = $job.inputs.border\n    z += \",\\n\\\n\tborder=\" + x\n  } else {\n    z += \",\\n\\\n\tborder=0.5\"\n  }\n  \n  if ($job.inputs.col_border) {\n    x = $job.inputs.col_border\n    z += \",\\n\\\n\tcol.border='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\tcol.border='#777777'\"\n  }\n  \n  if ($job.inputs.ramp_angle) {\n    x = $job.inputs.ramp_angle\n    z += \",\\n\\\n\tramp.angle=\" + x\n  } else {\n    z += \",\\n\\\n\tramp.angle=0.5\"\n  }\n  \n  if ($job.inputs.title) {\n    x = $job.inputs.title\n    z += \",\\n\\\n\ttitle='\" + x + \"'\"\n  } else {\n    z += \",\\n\\\n\ttitle='Fishplot of \" + tmp4 + \"'\"\n  }\n  \n  if ($job.inputs.cex_vlab) {\n    x = $job.inputs.cex_vlab\n    z += \",\\n\\\n\tcex.vlab=\" + x\n  } else {\n    z += \",\\n\\\n\tcex.vlab=0.7\"\n  }\n  \n  z += \")\\n\"\n  z += \"}\\n\"\n  z += \"save(fishes, file='\" + tmp4 + \".fishplot_model.RData')\\n\"\n  z += \"write.table(mat, file='\" + tmp4 + \".clonal_evolution_models.txt' , row.names=F, col.names=F)\\n\"\n  z += \"dev.off()\\n\\\n}\\n\\\nfishplot()\"\n  COMMAND +=z\n \n  \n  \n  \n  return COMMAND\n}"
                },
                "filename": "Fishplot.R"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#Fishplot_0_3.title_btm"
        },
        {
          "id": "#Fishplot_0_3.title"
        },
        {
          "id": "#Fishplot_0_3.shape"
        },
        {
          "id": "#Fishplot_0_3.ramp_angle"
        },
        {
          "id": "#Fishplot_0_3.pad_left"
        },
        {
          "id": "#Fishplot_0_3.input_file",
          "source": [
            "#ClonEvol_0_1.clonevol_model"
          ]
        },
        {
          "id": "#Fishplot_0_3.col_vline"
        },
        {
          "id": "#Fishplot_0_3.col_border"
        },
        {
          "id": "#Fishplot_0_3.cex_vlab"
        },
        {
          "id": "#Fishplot_0_3.cex_title"
        },
        {
          "id": "#Fishplot_0_3.border"
        }
      ],
      "outputs": [
        {
          "id": "#Fishplot_0_3.plotting_log"
        },
        {
          "id": "#Fishplot_0_3.fishplot_plots"
        },
        {
          "id": "#Fishplot_0_3.clonal_evolution_models"
        }
      ],
      "sbg:x": 1815.7201276506703,
      "sbg:y": 315.80326625279025
    },
    {
      "id": "#Bcftools_Filter",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "Output VCF file",
            "sbg:fileTypes": "VCF,BCF,VCF.GZ,BCF.GZ",
            "type": [
              "null",
              "File"
            ],
            "description": "Filtered VCF file.",
            "id": "#output_file",
            "outputBinding": {
              "glob": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  input_name = $job.inputs.input_file.path.split('/').pop().split('.').slice(0,-1).join('.')\n  switch($job.inputs.output_type) {\n      case 'CompressedBCF':\n          ext = '.filter.bcf.gz'\n          break;\n      case 'UncompressedBCF':\n          ext = '.filter.bcf'\n          break;\n      case 'CompressedVCF':\n          ext = '.filter.vcf.gz'\n          break;\n      default:\n          ext = '.filter.vcf'\n  }\n  return input_name + ext\n    \n}"
              },
              "sbg:inheritMetadataFrom": "#input_file"
            }
          }
        ],
        "sbg:toolkitVersion": "1.3",
        "inputs": [
          {
            "label": "Threads",
            "sbg:stageInput": null,
            "type": [
              "null",
              "int"
            ],
            "description": "Number of extra output compression threads [0].",
            "id": "#threads",
            "inputBinding": {
              "position": 23,
              "separate": true,
              "prefix": "--threads",
              "sbg:cmdInclude": true
            }
          },
          {
            "label": "Targets file",
            "sbg:altPrefix": "-T",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "Similar to Regions file option but streams rather than index-jumps.",
            "id": "#targets_file",
            "inputBinding": {
              "position": 22,
              "separate": true,
              "prefix": "--targets-file",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Targets",
            "description": "Similar to regions option but streams rather than index-jumps.",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 21,
              "separate": true,
              "prefix": "-t",
              "sbg:cmdInclude": true
            },
            "id": "#targets"
          },
          {
            "label": "Soft filter",
            "type": [
              "null",
              "string"
            ],
            "description": "Annotate FILTER column with <string> or unique filter name (\"Filter%d\") made up by the program (\"+\").",
            "id": "#soft_filter",
            "inputBinding": {
              "position": 19,
              "separate": true,
              "prefix": "-s",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "SNP gap",
            "type": [
              "null",
              "int"
            ],
            "description": "Filter SNPs within <int> base pairs of an indel.",
            "id": "#snp_gap",
            "inputBinding": {
              "position": 11,
              "separate": true,
              "prefix": "-g",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Set GTs",
            "type": [
              "null",
              "string"
            ],
            "description": "set genotypes of failed samples to missing (.) or ref (0).",
            "id": "#set_gts",
            "inputBinding": {
              "position": 20,
              "separate": true,
              "prefix": "-S",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Processing regions from file",
            "type": [
              "null",
              "File"
            ],
            "required": false,
            "description": "Restrict to regions listed in a file.",
            "id": "#regions_from_file",
            "inputBinding": {
              "loadContents": false,
              "position": 18,
              "separate": true,
              "prefix": "-R",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Regions for processing",
            "type": [
              "null",
              "string"
            ],
            "description": "Restrict to comma-separated list of regions.",
            "id": "#regions",
            "inputBinding": {
              "position": 17,
              "separate": true,
              "prefix": "-r",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Output type",
            "type": [
              "null",
              {
                "symbols": [
                  "CompressedBCF",
                  "UncompressedBCF",
                  "CompressedVCF",
                  "UncompressedVCF"
                ],
                "name": "output_type",
                "type": "enum"
              }
            ],
            "description": "b: compressed BCF, u: uncompressed BCF, z: compressed VCF, v: uncompressed VCF [v].",
            "id": "#output_type",
            "inputBinding": {
              "sbg:cmdInclude": true,
              "position": 16,
              "separate": false,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if($job.inputs.output_type === 'CompressedBCF') return 'b'\n  if($job.inputs.output_type === 'UncompressedBCF') return 'u'\n  if($job.inputs.output_type === 'CompressedVCF') return 'z'\n  if($job.inputs.output_type === 'UncompressedVCF') return 'v'\n}"
              },
              "prefix": "-O"
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Output file name",
            "description": "Name of the output file.",
            "type": [
              "null",
              "string"
            ],
            "id": "#output_name",
            "sbg:category": "Configuration"
          },
          {
            "label": "Filter mode",
            "description": "\"+\": do not replace but add to existing FILTER; \"x\": reset filters at sites which pass.",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 14,
              "separate": true,
              "prefix": "-m",
              "sbg:cmdInclude": true
            },
            "id": "#mode"
          },
          {
            "label": "input file name",
            "sbg:fileTypes": "VCF,VCF.GZ",
            "type": [
              "File"
            ],
            "required": true,
            "description": "Name of the input file.",
            "id": "#input_file",
            "inputBinding": {
              "position": 40,
              "separate": true,
              "sbg:cmdInclude": true
            },
            "sbg:category": "Input"
          },
          {
            "label": "Indel gap",
            "type": [
              "null",
              "string"
            ],
            "description": "Filter clusters of indels separated by <int> or fewer base pairs allowing only one to pass.",
            "id": "#indel_gap",
            "inputBinding": {
              "position": 12,
              "separate": true,
              "prefix": "-G",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "include expression",
            "type": [
              "null",
              "string"
            ],
            "description": "Include only sites for which the expression is true.",
            "id": "#include_expression",
            "inputBinding": {
              "position": 13,
              "separate": true,
              "prefix": "-i",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Exclude expression",
            "type": [
              "null",
              "string"
            ],
            "description": "Exclude sites for which the expression is true.",
            "id": "#exclude_expression",
            "inputBinding": {
              "position": 10,
              "separate": true,
              "prefix": "-e",
              "sbg:cmdInclude": true
            },
            "sbg:category": "Configuration"
          },
          {
            "label": "Compressed output",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "FALSE",
            "type": [
              "null",
              "boolean"
            ],
            "description": "Check to make the output compressed (usually for further processing).",
            "id": "#compressed",
            "sbg:category": "Execution"
          }
        ],
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1024
          },
          "inputs": {
            "soft_filter": "soft_filter-string-value",
            "include_expression": "'REF=\"C\"'",
            "targets": "targets-string-value",
            "output_name": "",
            "threads": 10,
            "input_file": {
              "path": "/path/to/input_file.some.vcf.gz",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "indel_gap": "indel_gap-string-value",
            "exclude_expression": "exclude_expression-string-value",
            "targets_file": {
              "path": "/path/to/targets_file.ext",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "regions_from_file": {
              "path": "/path/to/regions_from_file.ext",
              "size": 0,
              "secondaryFiles": [],
              "class": "File"
            },
            "regions": "regions-string-value",
            "mode": "mode-string-value",
            "compressed": true,
            "set_gts": "set_gts-string-value",
            "output_type": "UncompressedVCF",
            "snp_gap": null
          }
        },
        "sbg:toolkit": "bcftools",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "http://samtools.github.io/bcftools/"
          },
          {
            "label": "Source code",
            "id": "https://github.com/samtools/bcftools"
          },
          {
            "label": "Wiki",
            "id": "https://github.com/samtools/bcftools/wiki"
          },
          {
            "label": "Download",
            "id": "https://github.com/samtools/bcftools/archive/develop.zip"
          }
        ],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1024,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "21caaa02f72e",
            "dockerPull": "images.sbgenomics.com/vladimirk/bcftools:1.3",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          "bcftools",
          "filter"
        ],
        "sbg:revisionNotes": "Targets file.",
        "x": 231.24997103214363,
        "sbg:modifiedBy": "milan.domazet",
        "temporaryFailCodes": [
          1
        ],
        "sbg:toolAuthor": "Petr Danecek, Shane McCarthy, John Marshall",
        "cwlVersion": "sbg:draft-2",
        "sbg:categories": [
          "VCF-Processing"
        ],
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:project": "vladimirk/bcftools-1-3-demo",
        "sbg:validationErrors": [],
        "sbg:sbgMaintained": false,
        "label": "Bcftools Filter",
        "successCodes": [
          0
        ],
        "sbg:license": "MIT License",
        "sbg:createdOn": 1455276326,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "vladimirk",
        "sbg:id": "vladimirk/bcftools-1-3-demo/bcftools-1-3-filter/10",
        "sbg:latestRevision": 10,
        "id": "vladimirk/bcftools-1-3-demo/bcftools-1-3-filter/10",
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1455276326,
            "sbg:revisionNotes": null,
            "sbg:revision": 0,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1455717502,
            "sbg:revisionNotes": null,
            "sbg:revision": 1,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1458750367,
            "sbg:revisionNotes": null,
            "sbg:revision": 2,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1458750607,
            "sbg:revisionNotes": null,
            "sbg:revision": 3,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1458751282,
            "sbg:revisionNotes": null,
            "sbg:revision": 4,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1462442949,
            "sbg:revisionNotes": null,
            "sbg:revision": 5,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1462785588,
            "sbg:revisionNotes": null,
            "sbg:revision": 6,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1472138507,
            "sbg:revisionNotes": "Output file type",
            "sbg:revision": 7,
            "sbg:modifiedBy": "bogdang"
          },
          {
            "sbg:modifiedOn": 1474902887,
            "sbg:revisionNotes": "Support for vcf.gz",
            "sbg:revision": 8,
            "sbg:modifiedBy": "vladimirk"
          },
          {
            "sbg:modifiedOn": 1478267309,
            "sbg:revisionNotes": "Changed naming pattern",
            "sbg:revision": 9,
            "sbg:modifiedBy": "ognjenm"
          },
          {
            "sbg:modifiedOn": 1528981307,
            "sbg:revisionNotes": "Targets file.",
            "sbg:revision": 10,
            "sbg:modifiedBy": "milan.domazet"
          }
        ],
        "sbg:cmdPreview": "bcftools filter -o input_file.some.vcf.filter.vcf  /path/to/input_file.some.vcf.gz",
        "sbg:projectName": "BCFtools 1.3 Demo",
        "sbg:modifiedOn": 1528981307,
        "class": "CommandLineTool",
        "sbg:revision": 10,
        "sbg:contributors": [
          "milan.domazet",
          "bogdang",
          "ognjenm",
          "vladimirk"
        ],
        "arguments": [
          {
            "position": 3,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "class": "Expression",
              "script": "{\n  input_name = $job.inputs.input_file.path.split('/').pop().split('.').slice(0,-1).join('.')\n  switch($job.inputs.output_type) {\n      case 'CompressedBCF':\n          ext = '.filter.bcf.gz'\n          break;\n      case 'UncompressedBCF':\n          ext = '.filter.bcf'\n          break;\n      case 'CompressedVCF':\n          ext = '.filter.vcf.gz'\n          break;\n      default:\n          ext = '.filter.vcf'\n  }\n  return input_name + ext\n    \n}"
            },
            "prefix": "-o"
          }
        ],
        "stdout": "",
        "description": "Apply fixed-threshold filters.\n\nBCFtools is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart BCF. All commands work transparently with both VCFs and BCFs, both uncompressed and BGZF-compressed.\n\nMost commands accept VCF, bgzipped VCF and BCF with filetype detected automatically even when streaming from a pipe. Indexed VCF and BCF will work in all situations. Un-indexed VCF and BCF and streams will work in most, but not all situations. In general, whenever multiple VCFs are read simultaneously, they must be indexed and therefore also compressed.\n\nBCFtools is designed to work on a stream. It regards an input file \"-\" as the standard input (stdin) and outputs to the standard output (stdout). Several commands can thus be combined with Unix pipes.",
        "sbg:image_url": null,
        "y": 302.5194826263488,
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ]
      },
      "inputs": [
        {
          "id": "#Bcftools_Filter.threads"
        },
        {
          "id": "#Bcftools_Filter.targets_file"
        },
        {
          "id": "#Bcftools_Filter.targets"
        },
        {
          "id": "#Bcftools_Filter.soft_filter"
        },
        {
          "id": "#Bcftools_Filter.snp_gap"
        },
        {
          "id": "#Bcftools_Filter.set_gts"
        },
        {
          "id": "#Bcftools_Filter.regions_from_file"
        },
        {
          "id": "#Bcftools_Filter.regions"
        },
        {
          "id": "#Bcftools_Filter.output_type"
        },
        {
          "id": "#Bcftools_Filter.output_name"
        },
        {
          "id": "#Bcftools_Filter.mode"
        },
        {
          "id": "#Bcftools_Filter.input_file",
          "source": [
            "#VCFtools_Sort_1.output_file"
          ]
        },
        {
          "id": "#Bcftools_Filter.indel_gap"
        },
        {
          "id": "#Bcftools_Filter.include_expression",
          "default": "'FILTER=\".\" | FILTER=\"PASS\"'"
        },
        {
          "id": "#Bcftools_Filter.exclude_expression"
        },
        {
          "id": "#Bcftools_Filter.compressed"
        }
      ],
      "outputs": [
        {
          "id": "#Bcftools_Filter.output_file"
        }
      ],
      "sbg:x": 231.24997103214363,
      "sbg:y": 302.5194826263488,
      "scatter": "#Bcftools_Filter.input_file"
    },
    {
      "id": "#SBG_Compressor",
      "run": {
        "stdin": "",
        "outputs": [
          {
            "label": "Output archives",
            "sbg:fileTypes": "TAR, TAR.GZ, TAR.BZ2,  GZ, BZ2, ZIP",
            "id": "#output_archives",
            "description": "Newly created archives from the input files.",
            "type": [
              "File"
            ],
            "outputBinding": {
              "glob": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{ \n  function flatten(files){\n    var a = []\n  \tfor(var i=0;i<files.length;i++){\n      if(files[i]){\n        if(files[i].constructor == Array) {\n          a = a.concat(flatten(files[i]))\n        } else {\n          a = a.concat(files[i])\n        }\n      }\n    }\n    return a\n  }\n  \n  arr = [].concat($job.inputs.input_files)\n  return_array = []\n  return_array = flatten(arr)\n  new_list = return_array\n  \n  tmp = ''\n  \n  //NOT GOOD\n  sample_name = ''\n  for (i=0; i<new_list.length; i++) {\n    if (new_list[i].path.endsWith('.clusters')) {\n      tmp = new_list[i]\n      //add variant caller in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.variant_caller) {\n        var variant_caller = '.' + tmp.metadata.variant_caller\n      } else {\n        var variant_caller = ''\n      }\n      //add normal_id in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.normal_id) {\n        var normal_id = tmp.metadata.normal_id + '.'\n        var normal_id_2 = '-' + tmp.metadata.normal_id\n      } else {\n        var normal_id = ''\n        var normal_id_2 = ''\n      }\n      //add reference_handle in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.reference_handle) {\n        var reference_handle = '.' + tmp.metadata.reference_handle\n      } else {\n        var reference_handle = ''\n      }\n      \n      if (tmp.metadata && tmp.metadata.number_of_samples) {\n        if (tmp.metadata.number_of_samples==1) {\n          if ($job.inputs.output_naming && $job.inputs.output_naming=='Type2') {\n            if (tmp.metadata.sample_id) {\n              sample_name = tmp.metadata.sample_id + normal_id_2 + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + normal_id_2 + variant_caller + reference_handle\n            }\n          } else {\n            if (tmp.metadata.sample_id) {\n              sample_name = normal_id + tmp.metadata.sample_id + variant_caller + reference_handle\n            } else {\n              sample_name = normal_id + tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + variant_caller + reference_handle\n            }\n          }\n        } else {\n          if (tmp.metadata.case_id) {\n            if (tmp.metadata.Multi && tmp.metadata.Multi=='TN') {\n              sample_name = tmp.metadata.case_id + '-with-normal-' + normal_id.slice(0,normal_id.length-1) + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.metadata.case_id + variant_caller + reference_handle\n            }\n          } else {\n            if (tmp.metadata.Multi && tmp.metadata.Multi=='TN') {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + '-with-normal-' + normal_id.slice(0,normal_id.length-1) + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + variant_caller + reference_handle\n            }\n          }\n        }\n      }\n      break\n    } else if (new_list[i].path.endsWith('.cnv.txt')) {\n      tmp = new_list[i]\n      sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      break\n    } else if (new_list[i].path.endsWith('.hla_result.tsv')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.')[0]\n      }\n      break\n    } else if (new_list[i].path.endsWith('.msi_somatic')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.')\n      }\n      break\n    } else if (new_list[i].path.endsWith('.mutational_signatures_results.zip')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      }\n      break\n    } else if (new_list[i].path.endsWith('HC.vcf')) {\n      tmp = new_list[i]\n      sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      break\n    } else if (new_list[i].path.endsWith('fastqc.zip')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      }\n      break\n    }\n  }\n  \n\n  \n  if (tmp=='') {\n   tmp = new_list[0]\n   if (tmp.path) {\n     sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.')\n   }\n  }\n  if (sample_name == null) {\n    sample_name = \"output\"\n  }\n  \n  \n  if ($job.inputs.suffix) {\n    suffix = $job.inputs.suffix\n  } else {\n    suffix = \"results\"\n  }\n  \n  format = $job.inputs.output_format.toLowerCase()\n  \n  if ($job.inputs.output_name) {\n    return $job.inputs.output_name + \".\" + suffix + \".\" + format\n  } else {\n    return sample_name + \".\" + suffix + \".\" + format\n  }\n}"
              },
              "sbg:inheritMetadataFrom": "#input_files"
            }
          }
        ],
        "sbg:toolkitVersion": "v1.0",
        "inputs": [
          {
            "label": "Output suffix",
            "sbg:toolDefaultValue": "\"results\"",
            "id": "#suffix",
            "description": "Suffix to be added to the output archive",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Inputs"
          },
          {
            "label": "Output naming",
            "sbg:includeInPorts": true,
            "sbg:toolDefaultValue": "Type1",
            "id": "#output_naming",
            "description": "Output naming convention. Type1: normal.tumor; Type2: tumor-normal.",
            "type": [
              "null",
              {
                "symbols": [
                  "Type1",
                  "Type2"
                ],
                "name": "output_naming",
                "type": "enum"
              }
            ],
            "sbg:category": "Inputs",
            "required": false
          },
          {
            "label": "Output name",
            "sbg:toolDefaultValue": "output_archive",
            "id": "#output_name",
            "description": "Base name of the output archive. This parameter is not applicable for the GZ and BZ2 file formats.",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{ \n  function flatten(files){\n    var a = []\n  \tfor(var i=0;i<files.length;i++){\n      if(files[i]){\n        if(files[i].constructor == Array) {\n          a = a.concat(flatten(files[i]))\n        } else {\n          a = a.concat(files[i])\n        }\n      }\n    }\n    return a\n  }\n  \n  arr = [].concat($job.inputs.input_files)\n  return_array = []\n  return_array = flatten(arr)\n  new_list = return_array\n  \n  tmp = ''\n  \n  //NOT GOOD\n  sample_name = ''\n  for (i=0; i<new_list.length; i++) {\n    if (new_list[i].path.endsWith('.clusters')) {\n      tmp = new_list[i]\n      //add variant caller in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.variant_caller) {\n        var variant_caller = '.' + tmp.metadata.variant_caller\n      } else {\n        var variant_caller = ''\n      }\n      //add normal_id in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.normal_id) {\n        var normal_id = tmp.metadata.normal_id + '.'\n        var normal_id_2 = '-' + tmp.metadata.normal_id\n      } else {\n        var normal_id = ''\n        var normal_id_2 = ''\n      }\n      //add reference_handle in prefix to output names if it exists\n      if (tmp.metadata && tmp.metadata.reference_handle) {\n        var reference_handle = '.' + tmp.metadata.reference_handle\n      } else {\n        var reference_handle = ''\n      }\n      if (tmp.metadata && tmp.metadata.number_of_samples) {\n        if (tmp.metadata.number_of_samples==1) {\n          if ($job.inputs.output_naming && $job.inputs.output_naming=='Type2') {\n            if (tmp.metadata.sample_id) {\n              sample_name = tmp.metadata.sample_id + normal_id_2 + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + normal_id_2 + variant_caller + reference_handle\n            }\n          } else {\n            if (tmp.metadata.sample_id) {\n              sample_name = normal_id + tmp.metadata.sample_id + variant_caller + reference_handle\n            } else {\n              sample_name = normal_id + tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + variant_caller + reference_handle\n            }\n          }\n        } else {\n          if (tmp.metadata.case_id) {\n            if (tmp.metadata.Multi && tmp.metadata.Multi=='TN') {\n              sample_name = tmp.metadata.case_id + '-with-normal-' + normal_id.slice(0,normal_id.length-1) + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.metadata.case_id + variant_caller + reference_handle\n            }\n          } else {\n            if (tmp.metadata.Multi && tmp.metadata.Multi=='TN') {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + '-with-normal-' + normal_id.slice(0,normal_id.length-1) + variant_caller + reference_handle\n            } else {\n              sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.') + variant_caller + reference_handle\n            }\n          }\n        }\n      }\n      break\n    } else if (new_list[i].path.endsWith('.cnv.txt')) {\n      tmp = new_list[i]\n      sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      break\n    } else if (new_list[i].path.endsWith('.hla_result.tsv')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.')[0]\n      }\n      break\n    } else if (new_list[i].path.endsWith('.msi_somatic')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.')\n      }\n      break\n    } else if (new_list[i].path.endsWith('.mutational_signatures_results.zip')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      }\n      break\n    } else if (new_list[i].path.endsWith('HC.vcf')) {\n      tmp = new_list[i]\n      sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      break\n    } else if (new_list[i].path.endsWith('fastqc.zip')) {\n      tmp = new_list[i]\n      if (tmp.metadata && tmp.metadata.case_id) {\n      \tsample_name = tmp.metadata.case_id\n      } else {\n        sample_name = tmp.path.split('/').pop().split('.').slice(0,-2).join('.')\n      }\n      break\n    }\n  }\n  \n\n  \n  if (tmp=='') {\n   tmp = new_list[0]\n   if (tmp.path) {\n     sample_name = tmp.path.split('/').pop().split('.').slice(0,-1).join('.')\n   }\n  }\n  if (sample_name == null) {\n    sample_name = \"output\"\n  }\n  \n  \n  if ($job.inputs.suffix) {\n    suffix = $job.inputs.suffix\n  } else {\n    suffix = \"results\"\n  }\n   \n  if ($job.inputs.output_name) {\n    return \"--output_name \" + $job.inputs.output_name + \".\" + suffix\n  } else {\n    return \"--output_name \" + sample_name + \".\" + suffix \n  }\n}"
              },
              "sbg:cmdInclude": true
            }
          },
          {
            "label": "Output format",
            "id": "#output_format",
            "description": "Format of the output archive.",
            "type": [
              {
                "symbols": [
                  "TAR",
                  "TAR.GZ",
                  "TAR.BZ2",
                  "ZIP",
                  "GZ",
                  "BZ2"
                ],
                "name": "output_format",
                "type": "enum"
              }
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "--output_format"
            },
            "sbg:category": "Inputs"
          },
          {
            "label": "Input files",
            "sbg:stageInput": "copy",
            "type": [
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "The input files to be archived.",
            "id": "#input_files",
            "inputBinding": {
              "itemSeparator": null,
              "position": 0,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "--input_files"
            },
            "sbg:category": "Inputs",
            "required": true
          }
        ],
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "suffix": "tumor_heterogeneity_results",
            "output_name": "",
            "output_format": "ZIP",
            "input_files": [
              {
                "path": "/path/to/sampleN.sampleT.clusters",
                "metadata": {
                  "normal_id": "NORMAL",
                  "case_id": "CASE",
                  "number_of_samples": "2",
                  "sample_id": "SAMPLE",
                  "variant_caller": "CALLER",
                  "Multi": "TN"
                },
                "secondaryFiles": []
              },
              {
                "path": "/path/to/sampleN.sampleT.suffix3.ext",
                "size": 0,
                "secondaryFiles": [],
                "class": "File"
              }
            ],
            "output_naming": "Type1"
          }
        },
        "sbg:toolkit": "SBGTools",
        "sbg:copyOf": "uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/24",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "hints": [
          {
            "dockerImageId": "e0eb13970c8f",
            "dockerPull": "images.sbgenomics.com/milan_domazet/sbg-compressor:1.0",
            "class": "DockerRequirement"
          },
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          }
        ],
        "baseCommand": [
          "/opt/sbg_compressor.py",
          ""
        ],
        "sbg:modifiedBy": "uros_sipetic",
        "temporaryFailCodes": [],
        "sbg:toolAuthor": "Marko Petkovic, Seven Bridges Genomics",
        "requirements": [
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ],
        "sbg:categories": [
          "Other"
        ],
        "class": "CommandLineTool",
        "sbg:project": "uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo",
        "stdout": "",
        "sbg:homepage": "https://igor.sbgenomics.com/",
        "sbg:sbgMaintained": false,
        "label": "SBG Compressor",
        "successCodes": [],
        "sbg:license": "Apache License 2.0",
        "sbg:createdOn": 1511791795,
        "sbg:publisher": "sbg",
        "sbg:createdBy": "uros_sipetic",
        "sbg:image_url": null,
        "sbg:id": "uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo/sbg-compressor-1-0-custom/8",
        "sbg:latestRevision": 8,
        "id": "uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo/sbg-compressor-1-0-custom/8",
        "sbg:cmdPreview": "/opt/sbg_compressor.py  --input_files /path/to/sampleN.sampleT.clusters --input_files /path/to/sampleN.sampleT.suffix3.ext --output_format ZIP",
        "sbg:projectName": "Tumor Heterogeneity SciClone-based Workflow - Demo",
        "sbg:modifiedOn": 1534189927,
        "sbg:revisionsInfo": [
          {
            "sbg:modifiedOn": 1511791795,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/14",
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1516961978,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/16",
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1516962382,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/17",
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1516966669,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/19",
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1523910309,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/20",
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1523913887,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/21",
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1528299310,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/22",
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1534185577,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/23",
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic"
          },
          {
            "sbg:modifiedOn": 1534189927,
            "sbg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/24",
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic"
          }
        ],
        "sbg:revision": 8,
        "cwlVersion": "sbg:draft-2",
        "abg:revisionNotes": "Copy of uros_sipetic/cancer-pipeline-dev/sbg-compressor-1-0-custom/24",
        "arguments": [],
        "sbg:validationErrors": [],
        "description": "SBG Compressor performs the archiving(and/or compression) of the files provided on the input. The format of the output can be selected. \n\tSupported formats are:\n\t\t1. TAR\n\t\t2. TAR.GZ \n\t\t3. TAR.BZ2\n\t\t4. GZ\n\t\t5. BZ2\n\t\t6. ZIP\nFor formats TAR, TAR.GZ, TAR.BAZ2 and ZIP, single archive will be created on the output. For formats GZ and BZ2, one archive per file will be created.",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "x": 2156.6057477678582,
        "y": 324.66217041015636
      },
      "inputs": [
        {
          "id": "#SBG_Compressor.suffix",
          "default": "tumor_heterogeneity_results"
        },
        {
          "id": "#SBG_Compressor.output_naming",
          "source": [
            "#output_naming"
          ]
        },
        {
          "id": "#SBG_Compressor.output_name"
        },
        {
          "id": "#SBG_Compressor.output_format",
          "default": "ZIP"
        },
        {
          "id": "#SBG_Compressor.input_files",
          "source": [
            "#SBG_SciClone_report.tumor_heterogeneity_report",
            "#Fishplot_0_3.fishplot_plots",
            "#Fishplot_0_3.clonal_evolution_models",
            "#ClonEvol_0_1.clonevol_plots",
            "#SciClone_1_1.purity",
            "#SciClone_1_1.clusters",
            "#SciClone_1_1.clusterSummary",
            "#SciClone_1_1.sciclone_plots"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_Compressor.output_archives"
        }
      ],
      "sbg:x": 2156.6057477678582,
      "sbg:y": 324.66217041015636
    },
    {
      "id": "#SBG_SciClone_VCF_parser",
      "run": {
        "class": "CommandLineTool",
        "label": "SBG SciClone VCF parser",
        "description": "This tool parses a VCF file, containing calls for one or more samples, into the appropriate VAF files suitable for input to SciClone. It also outputs files with regions to exclude from SciClone analysis, most notably lines with VAFs higher than a certain threshold. \n\n### Common Issues ###\n1. In order for the tool to function properly for multiple samples, names of the samples in the VCF must be contained in the respective BAM file names. Otherwise, if there is just one input VCF file, the BAM input is not required.\n2. The VCF formats from the following variant callers are currently supported:\nMuSE\nEBCall\nDragen Somatic\nTNHaplotyper\nMuTect2\nVarScan2\nVarDict\nStrelka",
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": "\"\"\"\nA script that performs conversion of a standard VCF to a variant allele frequency (VAF) file, as required by SciClone.\n\"\"\"\nimport sys\nimport argparse\nimport vcf\nimport pysam\n\n\ndef parse_ebcall(rec):\n\t\"\"\"\n\tParses a VCF sample record written by EBCall.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepth = rec['DP']\n\talt_depth = rec['VN']\n\tref_depth = depth - alt_depth\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_maf_tcga_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written in MAF format for TCGA samples.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepths = rec['AD']\n\tref_depth = depths[0]\n\talt_depth = sum(depths[1:])\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_tnhap_mutect2_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by TNHaplotyper or MuTect2.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepths = rec['AD']\n\tref_depth = depths[0]\n\talt_depth = sum(depths[1:])\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\tif vaf==0:\n\t\tvaf = rec['AF']\n\t\tif type(vaf)==float:\n\t\t\tvaf = vaf*100\n\t\telif type(vaf)==list:\n\t\t\tvaf = vaf[vaf is not None]*100\n\t\telif vaf is None:\n\t\t\tvaf = 0\n\t\telse:\n\t\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_tnsnv_mutect1_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by TNSNV or MuTect1.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepths = rec['AD']\n\tref_depth = depths[0]\n\talt_depth = sum(depths[1:])\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_haplotypers_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by GATK or Sentieon haplotype callers.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepths = rec['AD']\n\tref_depth = depths[0]\n\talt_depth = sum(depths[1:])\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_muse_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by MuSE.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tdepths = rec['AD']\n\tref_depth = depths[0]\n\talt_depth = sum(depths[1:])\n\tif (ref_depth + alt_depth) != 0:\n\t\tvaf = float(alt_depth) / (ref_depth + alt_depth) * 100\n\telse:\n\t\tvaf = 0\n\treturn vaf, (ref_depth, alt_depth)\n\ndef parse_varscan_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by VarScan.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\treturn float(rec['FREQ'][:-1]), (rec['RD'], rec['AD'])\n\n\ndef parse_vardict_rec(rec):\n\t\"\"\"\n\tParses a VCF sample record written by VarDict.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tif type(rec['AF']) is float:\n\t\tvaf = rec['AF'] * 100\n\telse:\n\t\tvaf = [x for x in rec['AF'] if x is not None][0]*100\n\treturn vaf, (rec['DP'] - rec['VD'], rec['VD'])\n\n\t\ndef parse_strelka_rec(rec,ref,alt):\n\t\"\"\"\n\tParses a VCF sample record written by Strelka.\n\t:param rec: A PyVCF sample record.\n\t:return: (VAF, (ref_allele_dept, alt_allele_depth))\n\t\"\"\"\n\tREF_depth = rec[str(ref)+'U'][1]\n\tALT_depth = 0\n\tfor base in alt:\n\t\tALT_depth += rec[str(base)+'U'][1]\n\tif (float(ALT_depth)+float(REF_depth)) != 0:\n\t\tVAF = float(ALT_depth)/(float(ALT_depth)+float(REF_depth))\n\telse:\n\t\tVAF = 0\n\treturn VAF*100, (REF_depth,ALT_depth)  \n\t\n\t\ndef sniff_out_caller(suppl):\n\t\"\"\"\n\tTries to guess the caller that made a record.\n\t:param suppl: An instance of PyVCF Reader class.\n\t:raise ValueError: If the caller's identity could not be inferred.\n\t:return: The name of the caller.\n\t\"\"\"\n\tformat_recs = suppl.formats.keys()\n\tif 'ALT_F1R2' in format_recs:\n\t\treturn 'TNHaplotyper'\n\telif 'FA' in format_recs and 'SS' in format_recs and 'PL' in format_recs:\n\t\treturn 'TNSNV'\n\telif 'DP4' in format_recs:\n\t\treturn 'VarScan'\n\telif 'ADJAF' in format_recs or 'ALD' in format_recs:\n\t\treturn 'VarDict'\n\telif 'SS' in format_recs and 'BQ' in format_recs:\n\t\treturn 'MuSE'\n\telif 'SUBDP' in format_recs or 'SUBDP50' in format_recs:\n\t\treturn 'Strelka'\n\telif 'PL' in format_recs and 'GT' in format_recs:\n\t\treturn 'haplotypers'\n\telif 'GT' in format_recs and 'AD' in format_recs and 'DP'in format_recs :\n\t\treturn 'MAF_TCGA'\n\telif 'GT' in format_recs and 'VN' in format_recs and 'STR'in format_recs :\n\t\treturn 'EBCall'\n\telse:\n\t\traise ValueError('Could not infer the identity of the caller.')\n\n\ndef main(var_suppl, bam_dict, caller):\n\n\tif caller == 'TNHaplotyper':\n\t\textract_stats = parse_tnhap_mutect2_rec\n\telif caller == 'TNSNV':\n\t\textract_stats = parse_tnsnv_mutect1_rec\n\telif caller == 'MuSE':\n\t\textract_stats = parse_muse_rec\n\telif caller == 'VarScan':\n\t\textract_stats = parse_varscan_rec\n\telif caller == 'VarDict':\n\t\textract_stats = parse_vardict_rec\n\telif caller == 'Strelka':\n\t\textract_stats = parse_strelka_rec\n\telif caller == 'haplotypers':\n\t\textract_stats = parse_haplotypers_rec\n\telif caller == 'MAF_TCGA':\n\t\textract_stats = parse_maf_tcga_rec\n\telif caller == 'EBCall':\n\t\textract_stats = parse_ebcall\n\telse:\n\t\traise ValueError('Unknown caller')\n\n\twriters = {key: open(key + '.vaf', 'w') for key in bam_dict}  # there won't be any headers in the output files\n\n\tfor rec in var_suppl:\n\n\t\tif not rec.is_snp:\n\t\t\tcontinue\n\t\t\t\n\t\tif caller == 'Strelka':\n\t\t\tref = rec.REF\n\t\t\talt = rec.ALT\n\t\t\n\t\tfor sample in rec.samples:\n\n\t\t\t# First, try to handle the case of having VAF in FREQ, ALT allele depth in AD, and total depth in DP\n\t\t\ttry:\n\t\t\t\tif caller == 'Strelka':\n\t\t\t\t\tvaf, read_counts = extract_stats(sample,ref,alt)\n\t\t\t\telse:\n\t\t\t\t\tvaf, read_counts = extract_stats(sample)\n\t\t\texcept (AttributeError, ValueError, TypeError):\n\t\t\t\tvaf, read_counts = None, None\n\n\t\t\t# If that fails, we're doing the counting\n\t\t\tif vaf is None:\n\n\t\t\t\tread_counts = [0, 0]\n\t\t\t\tbam_suppl = bam_dict[sample.sample]\n\t\t\t\tfor read in bam_suppl.fetch(rec.CHROM, rec.start, rec.end):\n\t\t\t\t\tif read.is_duplicate:\n\t\t\t\t\t\tcontinue\n\t\t\t\t\tpos = rec.start - read.reference_start\n\t\t\t\t\tif pos < read.query_alignment_start or pos >= read.query_alignment_end:\n\t\t\t\t\t\tcontinue  # we're in soft-clipped territory\n\t\t\t\t\tbase = read.query_sequence[pos]\n\t\t\t\t\tif base == rec.REF:\n\t\t\t\t\t\tread_counts[0] += 1\n\t\t\t\t\telif base in rec.ALT:\n\t\t\t\t\t\tread_counts[1] += 1\n\n\t\t\t\tif read_counts[1] == 0:\n\t\t\t\t\tvaf = 0.00\n\t\t\t\telse:\n\t\t\t\t\tvaf = float(read_counts[1]) / sum(read_counts) * 100\n\t\t\t\n\t\t\tif vaf != 0:\n\t\t\t\twriter = writers[sample.sample]\n\t\t\t\t# Important: we're assuming here SciClone expects 1-based indexing\n\t\t\t\twriter.write('{}\\t{}\\t{}\\t{}\\t{}\\n'.format(rec.CHROM, rec.POS, read_counts[0], read_counts[1], vaf))\n\nif __name__ == '__main__':\n\n\tparser = argparse.ArgumentParser(description=\"\"\"\n\tPerform conversion of a VCF to a variant allele frequency file required by SciClone.\n\n\tThe script requires that an indexed BAM file is supplied for each sample from the VCF.\n\tName of the sample must be contained in the name of the respective BAM file, otherwise, the script will fail.\"\"\")\n\tparser.add_argument('--vcf', dest='vcf', required=True, type=str)\n\tparser.add_argument('--bams', dest='bams', type=str)\n\tparser.add_argument('--sample_ids', dest='sample_ids',type=str)\n\targs = parser.parse_args()\n\tif args.bams:\n\t\targs.bams = args.bams.split(',')\n\tif args.sample_ids:\n\t\targs.sample_ids = args.sample_ids.split(',')\n\t\n\tsuppl = vcf.Reader(filename=args.vcf)  # this should handle gzipped input out-of-the-box\n\tcaller = sniff_out_caller(suppl)\n\trec = suppl.next()\n\tsamples = [sample.sample for sample in rec.samples]\n\tif (len(samples) != 1):\n\t\tif len(samples) != len(args.bams):\n\t\t\tsys.stderr.write('Number of samples in the VCF does not match the number of BAM files provided.')\n\t\t\tsys.exit(1)\n\n\tbams = {}\n\t\n\tfor sample in samples:\n\t\tif len(samples) > 1:\n\t\t\tif (args.sample_ids) and (len(args.sample_ids) == len(args.bams)) and (sample in args.sample_ids):\n\t\t\t\tmatching_bam = args.bams[args.sample_ids.index(sample)]\n\t\t\t\tbams[sample] = pysam.AlignmentFile(matching_bam, 'rb')\n\t\t\telse: \n\t\t\t\tmatching_bam = [bam for bam in args.bams if sample in bam.split('/')[-1]]\n\t\t\t\tif len(matching_bam) == 0:\n\t\t\t\t\tsys.stderr.write('No matching BAM file found for sample: ' + sample)\n\t\t\t\t\tsys.exit(1)\n\t\t\t\telif len(matching_bam) > 1:\n\t\t\t\t\tsys.stderr.write('Could not match sample ' + sample + ' to a single BAM unambiguously.')\n\t\t\t\t\tsys.exit(1)\n\n\t\t\t\tmatching_bam = matching_bam[0]\n\t\t\t\t#source_dir = '/'.join(matching_bam.split('/')[:-1])\n\t\t\t\t#dir_content = os.listdir(source_dir) if source_dir else os.listdir('.')\n\t\t\t\t#if not (matching_bam[:-3] + 'bai' in dir_content) and not (matching_bam + '.bai' in dir_content):\n\t\t\t\t#    print 'Missing index file for', matching_bam\n\t\t\t\t#    sys.exit(1)\n\t\t\t\tbams[sample] = pysam.AlignmentFile(matching_bam, 'rb')\n\t\telse: \n\t\t\tbams[sample] = None\n\tvar_suppl = vcf.Reader(filename=args.vcf)  # reopen the thing so we seek back to the first record (not particularly elegant)\n\n\tmain(var_suppl=var_suppl, bam_dict=bams, caller=caller)",
                "filename": "vcf_parser.py"
              },
              {
                "fileContent": "import argparse\n\nparser = argparse.ArgumentParser(description='This scripts takes a file with VAF information and produces a file with lines only above a certain VAF threshold.')\nparser.add_argument('-i','--input', help='Input VAF file', required=True)\nparser.add_argument('-t','--threshold', type=float, default=70, help='VAF threshold. All input file lines with VAFs above this value will be written to the output file. Input should be a float number between 0 and 100. ', required=False)\n\nargs = vars(parser.parse_args())\n\nvaf_file = args['input']\nthreshold = args['threshold']\noutput_file = ('.').join(vaf_file.split('.')[0:-1]) + '.regions.vaf_high.txt'\np = ''\nk = 0\nwith open(vaf_file) as f:\n    for line in f:\n        x = line.split('\\t')\n        if k==0:\n            chr_name = x[0]\n            k = 1\n        if float(x[4])>threshold:\n            p += x[0] + '\\t' + x[1] + '\\t' + x[1] + '\\n'\nif p=='':\n    p = chr_name + '\\t' + '1' + '\\t' + '1' + '\\n'\nwith open(output_file,\"w\") as f:\n    f.write(p)",
                "filename": "regions_to_exclude.py"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ],
        "inputs": [
          {
            "sbg:category": "Inputs",
            "sbg:fileTypes": "VCF",
            "type": [
              "File"
            ],
            "label": "VCF file",
            "id": "#vcf",
            "description": "A VCF file with one or more sample columns.",
            "inputBinding": {
              "position": 0,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "--vcf"
            },
            "required": true
          },
          {
            "sbg:category": "Inputs",
            "id": "#vaf_threshold",
            "label": "VAF threshold",
            "type": [
              "null",
              "float"
            ],
            "sbg:toolDefaultValue": "70",
            "description": "Lines with VAF values above this threshold will be written to the file with regions to exclude from SciClone analysis."
          },
          {
            "sbg:category": "Inputs",
            "sbg:fileTypes": "BAM",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "label": "BAM file(s)",
            "id": "#bams",
            "description": "Indexed BAM files, one for each sample in the provided VCF, if there are multiple VCFs.",
            "inputBinding": {
              "position": 1,
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "script": "{\n  var y = $job.inputs.bams\n  if (y && y!=='') {\n    var x = [].concat(y)\n    var cmd = ''\n    for (i=0; i<x.length; i++) {\n      cmd += x[i].path + ','\n    }\n    return '--bams ' + cmd.slice(0,cmd.length-1)\n  } else {\n    return ''\n  }\n}",
                "class": "Expression"
              },
              "sbg:cmdInclude": true,
              "itemSeparator": ",",
              "separate": true,
              "secondaryFiles": [
                ".bai"
              ]
            },
            "required": false
          }
        ],
        "outputs": [
          {
            "sbg:fileTypes": "VAF",
            "id": "#vafs",
            "label": "SciClone VAF file(s)",
            "outputBinding": {
              "glob": "*.vaf",
              "sbg:metadata": {
                "reference_handle": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  var x = [].concat($job.inputs.vcf)[0].path.split('/').pop()\n  if (x.toLowerCase().indexOf('hg19') != -1) {\n    return 'hg19'\n  } else if (x.toLowerCase().indexOf('hg38') != -1) {\n    return 'hg38'\n  } else if (x.toLowerCase().indexOf('grch37') != -1) {\n    return 'grch37'\n  } else if (x.toLowerCase().indexOf('grch38') != -1) {\n    return 'grch38'\n  } else {\n    return ''\n  }\n}",
                  "class": "Expression"
                },
                "normal_id": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  var vcf = [].concat($job.inputs.vcf)[0]\n  if (vcf.metadata && vcf.metadata['normal_id'] && vcf.metadata['normal_id'].toLowerCase()!='na') {\n    return vcf.metadata['normal_id']\n  } else if (vcf.metadata && vcf.metadata['Normal ID'] && vcf.metadata['Normal ID'].toLowerCase()!='na'){\n    return vcf.metadata['Normal ID']\n  } else {\n    return \"\"\n  }\n}",
                  "class": "Expression"
                },
                "sample_id": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  return $self.path.split('/').pop().split('.')[0]\n}",
                  "class": "Expression"
                },
                "variant_caller": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  var x = [].concat($job.inputs.vcf)[0].path.split('/').pop()\n  if (x.toLowerCase().indexOf('tnsnv') != -1) {\n    return 'TNsnv'\n  } else if (x.toLowerCase().indexOf('tnscope') != -1) {\n    return 'TNscope'\n  } else if (x.toLowerCase().indexOf('strelka2') != -1) {\n    return 'Strelka2'\n  } else if (x.toLowerCase().indexOf('strelka') != -1) {\n    return 'Strelka1'\n  } else {\n    return ''\n  }\n}",
                  "class": "Expression"
                }
              },
              "sbg:inheritMetadataFrom": "#vcf"
            },
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "File appropriate to use for SciClone VAF input."
          },
          {
            "sbg:fileTypes": "TXT",
            "id": "#regions_to_exclude",
            "label": "Regions to exclude",
            "outputBinding": {
              "glob": "*.vaf_high.txt",
              "sbg:metadata": {
                "sample_id": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  return $self.path.split('/').pop().split('.')[0]\n}",
                  "class": "Expression"
                }
              },
              "sbg:inheritMetadataFrom": "#vcf"
            },
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "description": "Files with regions to exclude, one for each inut sample. These files contain lines with mutations that have VAFs higher than the specified threshold."
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": 1000
          },
          {
            "dockerPull": "images.sbgenomics.com/dusan_randjelovic/sci-python:2.7",
            "class": "DockerRequirement",
            "dockerImageId": ""
          }
        ],
        "baseCommand": [
          "python",
          "vcf_parser.py"
        ],
        "stdin": "",
        "stdout": "",
        "successCodes": [],
        "temporaryFailCodes": [],
        "arguments": [
          {
            "position": 99,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "script": "{\n  if ($job.inputs.vaf_threshold) {\n  \tvar vaf_threshold = $job.inputs.vaf_threshold\n  } else {\n    var vaf_threshold = 70\n  }\n  return \" && for f in ./*.vaf; do python regions_to_exclude.py -i $f -t \" + vaf_threshold + \"; done\"\n}",
              "class": "Expression"
            },
            "separate": true
          },
          {
            "position": 3,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "script": "{\n  var bams = [].concat($job.inputs.bams)\n  if (bams[0] && bams[0].metadata && bams[0].metadata.sample_id) {\n    var samples = []\n    for (i=0; i<bams.length; i++) {\n      samples = samples.concat(bams[i].metadata.sample_id)\n    }\n    return '--sample_ids ' + samples\n  } else {\n    return ''\n  }\n}",
              "class": "Expression"
            },
            "separate": true,
            "prefix": ""
          }
        ],
        "sbg:toolAuthor": "Seven Bridges Genomics",
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:toolkit": "SBGTools",
        "abg:revisionNotes": "Update normal_id expression",
        "sbg:cmdPreview": "python vcf_parser.py --vcf /path/to/sample_nstrelkaihnf.vcf     && for f in ./*.vaf; do python regions_to_exclude.py -i $f -t 70; done",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1477578447,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/1"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1479839117,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/2"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1481733749,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/4"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485253402,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/8"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485273466,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/9"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485276239,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/10"
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485294227,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/11"
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485298381,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/12"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485342249,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/13"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485351136,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/14"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485361748,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/15"
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485947568,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/16"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485960600,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/17"
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1491832158,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/18"
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1494348652,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/19"
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1494435591,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/20"
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1494437308,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/21"
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1494516148,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/22"
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498039914,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/25"
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1507659554,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/32"
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1507661053,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/33"
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509561404,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/34"
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509650079,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/35"
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1520595019,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/36"
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1523962450,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/37"
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526387829,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/38"
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1527007862,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/39"
          },
          {
            "sbg:revision": 27,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1527089271,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/40"
          },
          {
            "sbg:revision": 28,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528241926,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/41"
          },
          {
            "sbg:revision": 29,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1529248535,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/42"
          },
          {
            "sbg:revision": 30,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1530104155,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/43"
          },
          {
            "sbg:revision": 31,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1533570823,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/44"
          },
          {
            "sbg:revision": 32,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1533910219,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/45"
          },
          {
            "sbg:revision": 33,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1533916519,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/46"
          },
          {
            "sbg:revision": 34,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1534189617,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/47"
          },
          {
            "sbg:revision": 35,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1534515469,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/48"
          },
          {
            "sbg:revision": 36,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548428837,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/49"
          },
          {
            "sbg:revision": 37,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548430031,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/50"
          }
        ],
        "sbg:categories": [
          "Other"
        ],
        "sbg:toolkitVersion": "v1.0",
        "sbg:license": "Apache License 2.0",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "bams": null,
            "vaf_threshold": null,
            "vcf": {
              "size": 0,
              "metadata": {
                "Normal ID": "NORMAL"
              },
              "class": "File",
              "secondaryFiles": [],
              "path": "/path/to/sample_nstrelkaihnf.vcf"
            }
          }
        },
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "cwlVersion": "sbg:draft-2",
        "sbg:image_url": null,
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "bix-demo/sbgtools-demo/sbg-sciclone-vcf-parser/37",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-sciclone-vcf-parser/37",
        "sbg:revision": 37,
        "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/50",
        "sbg:modifiedOn": 1548430031,
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:createdOn": 1477578447,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "sbg:latestRevision": 37,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a0641e13a67b51688c994286b8cc17c803288e3d419899080fe0e1038872e1f4f",
        "sbg:copyOf": "uros_sipetic/sciclone-1-1-demo/sbg-sciclone-vcf-parser/50",
        "x": 651.2499237060548,
        "y": 296.2695312500001
      },
      "inputs": [
        {
          "id": "#SBG_SciClone_VCF_parser.vcf",
          "source": [
            "#VCFtools_Merge.output_file"
          ]
        },
        {
          "id": "#SBG_SciClone_VCF_parser.vaf_threshold",
          "default": 60,
          "source": [
            "#vaf_threshold"
          ]
        },
        {
          "id": "#SBG_SciClone_VCF_parser.bams",
          "source": [
            "#bams"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_SciClone_VCF_parser.vafs"
        },
        {
          "id": "#SBG_SciClone_VCF_parser.regions_to_exclude"
        }
      ],
      "sbg:x": 651.2499237060548,
      "sbg:y": 296.2695312500001
    },
    {
      "id": "#SBG_Get_LOH_Regions",
      "run": {
        "cwlVersion": "sbg:draft-2",
        "class": "CommandLineTool",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "label": "SBG Get LOH Regions",
        "description": "This tool find LOH regions from CNV called data.",
        "baseCommand": [
          {
            "class": "Expression",
            "engine": "#cwl-js-engine",
            "script": "{\n    if ($job.inputs.cnv_file === null || $job.inputs.cnv_file === [] ||\n    [].concat($job.inputs.cnv_file).length <1){\n        return \"echo 'No cnv file provided'\"\n    }\n    else{\n    return 'python3.4 cnv_pass.py'\n}\n}"
          }
        ],
        "inputs": [
          {
            "sbg:category": "Input",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-o",
              "separate": true,
              "valueFrom": {
                "class": "Expression",
                "engine": "#cwl-js-engine",
                "script": "{\n  if ($job.inputs.output_filename) {return $job.inputs.output_filename + '.regions.loh'}\n  else {\n      if ([].concat($job.inputs.cnv_file)<1 || $job.inputs.cnv_file ===null ||\n      $job.inputs.cnv_file===[]){ return ''}\n      else{\n        var x = [].concat($job.inputs.cnv_file)\n        var y = x[0].path.split('/').pop().split('.').slice(0,-1).join('.')\n        return y +'.regions.loh'\n  \t}\n  }\n}"
              },
              "sbg:cmdInclude": true
            },
            "label": "Output file name",
            "description": "Output file name",
            "id": "#output_filename",
            "required": false
          },
          {
            "sbg:category": "Input",
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-cnv",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "CNV input file",
            "description": "CNV input file.",
            "id": "#cnv_file",
            "required": false
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "label": "Output LOH file",
            "description": "File with LOH regions.",
            "sbg:fileTypes": "LOH",
            "outputBinding": {
              "glob": "*.loh",
              "sbg:inheritMetadataFrom": "#cnv_file"
            },
            "id": "#output_file"
          }
        ],
        "requirements": [
          {
            "class": "ExpressionEngineRequirement",
            "id": "#cwl-js-engine",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ]
          },
          {
            "class": "CreateFileRequirement",
            "fileDef": [
              {
                "filename": "cnv_pass.py",
                "fileContent": "import sys\nimport argparse\n\n\ndef cnv_pass(cnv_file, output_filename):\n    fajl = open(cnv_file, 'r')\n\n    for line in fajl:\n        first_line = line\n        break\n\n    cn_list = ['cn', 'cn1', 'cn2']\n\n    super_file = {'chrom': [],\n                  'start': [],\n                  'end': []}\n\n    if set(cn_list) < set(first_line.strip('\\n').split('\\t')):\n\n        # CNVkit\n\n        # cn_index = first_line.strip('\\n').split('\\t').index('total-copy-number')\n        # cn1_index = first_line.strip('\\n').split('\\t').index('copy-number-1')\n        # cn2_index = first_line.strip('\\n').split('\\t').index('copy-number-2')\n\n        # SBG CNV Converter\n\n        cn_index = first_line.strip('\\n').split('\\t').index('cn')\n        cn1_index = first_line.strip('\\n').split('\\t').index('cn1')\n        cn2_index = first_line.strip('\\n').split('\\t').index('cn2')\n        for line in fajl:\n            cnvs = [line.strip('\\n').split('\\t')[cn_index],\n                    line.strip('\\n').split('\\t')[cn1_index],\n                    line.strip('\\n').split('\\t')[cn2_index]]\n\n            if (len(line.strip('\\n').split('\\t')[0])) >= 3:\n                chrom = 'chr'\n            else:\n                chrom = ''\n\n            if cnvs == ['2.0', '2.0', '0.0'] or cnvs == [\n                '2.0', '0.0', '2.0'] or cnvs == [\n                '2', '2', '0'] or cnvs == ['2', '0', '2']:\n\n                super_file['chrom'].append(line.strip('\\n').split('\\t')[0])\n                super_file['start'].append((line.strip('\\n').split('\\t')[1]))\n                super_file['end'].append(line.strip('\\n').split('\\t')[2])\n\n        if not (super_file['chrom']):\n            super_file['chrom'].append(chrom + '1')\n            super_file['start'].append('1')\n            super_file['end'].append('1')\n\n    else:\n        for line in fajl:\n            if (len(line.strip('\\n').split('\\t')[0])) >= 3:\n                chrom = 'chr'\n            else:\n                chrom = ''\n\n        super_file['chrom'].append(chrom + '1')\n        super_file['start'].append('1')\n        super_file['end'].append('1')\n\n    orig_stdout = sys.stdout\n    f = open(output_filename, 'w')\n    sys.stdout = f\n\n    for i in range(len(super_file['chrom'])):\n        print('{}\\t{}\\t{}'.format(super_file['chrom'][i],\n                                  super_file['start'][i],\n                                  super_file['end'][i]))\n\n    sys.stdout = orig_stdout\n    f.close()\n\n\ndef parse_arguments():\n    parser = argparse.ArgumentParser(\n        description='This finds LOH regions in the CNV file'\n    )\n    parser.add_argument('-cnv', '--cnv_file', help='CNV file', required=True)\n    parser.add_argument(\n        '-o', '--output_filename', help='Output filename', required=True\n    )\n\n    args = vars(parser.parse_args())\n    cnv_file = args['cnv_file']\n    output_filename = args['output_filename']\n\n    return cnv_pass(cnv_file=cnv_file, output_filename=output_filename)\n\n\nobj = parse_arguments()\n"
              }
            ]
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": 1000
          },
          {
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/sevenbridges/ubuntu:14.04"
          }
        ],
        "sbg:image_url": null,
        "sbg:cmdPreview": "python3.4 cnv_pass.py",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528130327,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/1"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528189119,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/2"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1545926752,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/3"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548428828,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/4"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "vojislav_varjacic",
            "sbg:modifiedOn": 1560941810,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/5"
          }
        ],
        "sbg:job": {
          "inputs": {
            "output_filename": "",
            "cnv_file": {
              "class": "File",
              "metadata": {
                "sample_id": "hc11"
              },
              "path": "/path/to/cnv_file.ext",
              "secondaryFiles": [],
              "size": 0
            }
          },
          "allocatedResources": {
            "mem": 1000,
            "cpu": 1
          }
        },
        "sbg:toolkitVersion": "1.0",
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:toolkit": "SBGtools",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "bix-demo/sbgtools-demo/sbg-get-loh-regions/4",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-get-loh-regions/4",
        "sbg:revision": 4,
        "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/5",
        "sbg:modifiedOn": 1560941810,
        "sbg:modifiedBy": "vojislav_varjacic",
        "sbg:createdOn": 1528130327,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic",
          "vojislav_varjacic"
        ],
        "sbg:latestRevision": 4,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "ab6d86871d202b6fdea8b48337e377d9883a05aa57644a56226615877aac40ccd",
        "sbg:copyOf": "uros_sipetic/sciclone-1-1-demo/sbg-get-loh-regions/5",
        "x": 652.8571428571431,
        "y": 434.28571428571445,
        "appUrl": "/u/bix-demo/sbgtools-demo/apps/#bix-demo/sbgtools-demo/sbg-get-loh-regions/4"
      },
      "inputs": [
        {
          "id": "#SBG_Get_LOH_Regions.output_filename"
        },
        {
          "id": "#SBG_Get_LOH_Regions.cnv_file",
          "source": [
            "#SBG_CNV_Converter.converted_files"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_Get_LOH_Regions.output_file"
        }
      ],
      "sbg:x": 652.8571428571431,
      "sbg:y": 434.28571428571445,
      "scatter": "#SBG_Get_LOH_Regions.cnv_file"
    },
    {
      "id": "#SciClone_1_1",
      "run": {
        "class": "CommandLineTool",
        "label": "SciClone 1.1",
        "description": "SciClone identifies sub-clones within a sequenced sample. The software integrates read depth and copy number information at single nucleotide variant locations and clusters the variants in copy neutral regions, to formalize description of the sub-clonal architecture of the sample. \n\nThe input files are:\n\n1. VAF files, which can be parsed from most VCF files - required.\n\n2. CNV files, which can be obtained from most CNV callers - optional, but highly recommended. \n\n3. LOH files, regions to be excluded, which can be obtained from tools like Varscan2 - optional, recommended to increase accuracy.\n\n### Common Issues ###\n\n1. Make sure you correctly parse the VCF files to the proper input VAF files using the SBG SciClone VCF parser tool. \n\n2. The 3D rgl R plot currently does not work due to docker 3D plotting limitations.\n\n3. If you're providing multiple samples and you want to preserve the chronological order for tracking of the tumor's evolution by downstream tools such as ClonEvol and Fishplot, please provide the correct sample order by using the 'sample_order' input parameter.",
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  // define a function for flattening, used for exluding regions\n  function flatten(files){\n    var a = []\n  \tfor(var i=0;i<files.length;i++){\n      if(files[i]){\n        if(files[i].constructor == Array) {\n          a = a.concat(flatten(files[i]))\n        } else {\n          a = a.concat(files[i])\n        }\n      }\n    }\n    return a\n  }\n  \n  // define a function for sorting objects by property\n  var byProperty = function(prop, reverse) {\n    return function(a, b) {\n      if (typeof a[prop] === 'number') {\n        return (a[prop] - b[prop]);\n      }\n      if (a[prop] < b[prop]) {\n        return reverse ? 1 : -1;\n      }\n      if (a[prop] > b[prop]) {\n        return reverse ? -1 : 1;\n      }\n      return 0;\n    }\n  }\n  \n  // define another function for sorting objects by property\n  function sortObj(list, key) {\n    function compare(a, b) {\n      a = a[key]\n      b = b[key]\n      var type = (typeof(a) === 'string' || typeof(b) === 'string') ? 'string' : 'number';\n      var result\n      if (type === 'string') {\n        result = a.localeCompare(b)\n      } else {\n        result = a - b\n      }\n      return result\n    }\n    return list.sort(compare)\n  }\n  \n\n  // Start sciClone here\n  var COMMAND = \"library(sciClone)\\n\"\n  \n  //read in vaf data from three related tumors\n  //format is 5 column, tab delimited: \n  //chr, pos, ref_reads, var_reads, vaf\n  \n  //do sorting of vafs per chronological order - important for Fishplot\n  \n  var vafs = [].concat($job.inputs.vafs)\n  var sorted_vafs = sortObj(vafs,'path')\n  var vafs = [].concat($job.inputs.vafs)  \n  \n  var sample_order = $job.inputs.sample_order\n  if (!$job.inputs.sample_order) {\n  \tordered_vafs = sorted_vafs\n  } else if (vafs.length==1) {\n    ordered_vafs = vafs\n  } else if (vafs.length != sample_order.length) {\n    ordered_vafs = sorted_vafs\n  } else {\n    var ordered_vafs = []\n    for (k=0; k<sample_order.length; k++) {\n  \t  for (i=0; i<vafs.length; i++) {\n        if (sample_order[k].indexOf(vafs[i].metadata.sample_id)!=-1) {\n      \t  ordered_vafs = ordered_vafs.concat(vafs[i])\n          break\n        }\n      }\n    }\n  }\n  if (ordered_vafs.length!=vafs.length) {\n    ordered_vafs = sorted_vafs\n  }\n  \n  x = ordered_vafs\n  for (i=0; i<x.length; i++) {\n    y = x[i].path.split('/').pop()\n    z = \"v\" + (i+1) + \" = read.table('\" + y + \"',header=F);\\n\"\n    COMMAND += z\n  }\n  \n  //read in regions to exclude (commonly LOH)\n  //format is 3-col bed\n  regions_flag = false\n  if ($job.inputs.regionsToExclude) {\n  regions_flag = true\n  temp = [].concat($job.inputs.regionsToExclude)\n  x = []\n  x = flatten(temp)\n  sortObj(x,'path')\n  for (i=0; i<x.length; i++) {\n    y = x[i].path.split('/').pop()\n    z = \"regions\" + (i+1) + \" = read.table('\" + y + \"');\\n\"\n    COMMAND += z\n  }\n  }\n  \n  //read in segmented copy number data\n  //4 columns - chr, start, stop, segment_mean\n  cn_flag = false\n  var tmp_cnv = [].concat($job.inputs.copyNumberCalls)\n  x = []\n  x = flatten(tmp_cnv)\n  if (x[0] && x[0].path) {\n  cn_flag = true\n  cnvs = [].concat($job.inputs.copyNumberCalls)\n  x = []\n  x = flatten(cnvs)\n  cnvs = x\n  vafs = ordered_vafs\n  \n  //if one sample provided\n  if (vafs.length==1 && cnvs.length==1) {\n    y = cnvs[0].path.split('/').pop()\n    z = \"cn\" + (0+1) + \" = read.table('\" + y + \"',header=T,sep='\\\\t');\\n\"\n    COMMAND += z\n  }\n  //if sample_id exists, pair cnvs and vafs by sample_id\n  else if (cnvs[0].metadata && cnvs[0].metadata.sample_id && vafs[0].metadata && vafs[0].metadata.sample_id) {\n    for (i=0; i<vafs.length; i++) {\n      for (j=0; j<cnvs.length; j++) {\n        if (cnvs[j].metadata.sample_id == vafs[i].metadata.sample_id) {\n          y = cnvs[j].path.split('/').pop()\n          z = \"cn\" + (i+1) + \" = read.table('\" + y + \"',header=T,sep='\\\\t');\\n\"\n          COMMAND += z\n        }\n      }\n    }\n  }\n  //else pair cnvs and vafs by sample_name\n  else {\n    for (i=0; i<vafs.length; i++) {\n      for (j=0; j<cnvs.length; j++) {\n        if (cnvs[j].path.split('.')[0] == vafs[i].path.split('.')[0]) {\n          y = cnvs[j].path.split('/').pop()\n          z = \"cn\" + (i+1) + \" = read.table('\" + y + \"',header=T,sep='\\\\t');\\n\"\n          COMMAND += z\n        }\n      }\n    }\n  }\n   \n  // parse CNV results - currently, sciClone assumes columns 1,2,3,4 are what it needs  \n  x = cnvs\n  for (i=0; i<x.length; i++) {\n    y = '[,c(1,2,3,4)]'\n    z = \"cn\" + (i+1) + \" = cn\" + (i+1) + y + \";\\n\"\n    COMMAND += z\n  }  \n  }\n  \n  //set sample names\n  x = ordered_vafs\n  s = []\n  for (i=0; i<x.length; i++) {\n    if (x[i].metadata && x[i].metadata.sample_id) {\n      s[i] = x[i].metadata.sample_id\n    } else {\n      s[i] = x[i].path.split('/').pop().split('.')[0]\n    }\n  }\n  z = \"names = c(\"\n  for (i=0; i<s.length; i++) {\n    if (i<s.length-1) {\n      z = z + \"'\" + s[i] + \"',\"\n    } else {\n      z = z + \"'\" + s[i] + \"');\\n\"\n    }\n  }\n  COMMAND += z\n  \n  //do clustering\n  vafs = ''\n  copyNumberCalls = ''\n  regionsToExclude = ''\n  temp = [].concat($job.inputs.regionsToExclude)\n  x = []\n  x = flatten(temp)\n  for (i=0; i<x.length;i++) {\n    if (i<x.length-1) {\n      regionsToExclude += 'regions' + (i+1) + ','\n    } else {\n      regionsToExclude += 'regions' + (i+1)\n    }\n  }\n  x = [].concat($job.inputs.copyNumberCalls)\n  for (i=0; i<x.length;i++) {\n    if (i<x.length-1) {\n      copyNumberCalls += 'cn' + (i+1) + ','\n    } else {\n      copyNumberCalls += 'cn' + (i+1)\n    }\n  }\n  x = ordered_vafs\n  for (i=0; i<x.length;i++) {\n    if (i<x.length-1) {\n      vafs += 'v' + (i+1) + ','\n    } else {\n      vafs += 'v' + (i+1)\n    }\n  }\n  z = \"sc = sciClone(vafs=list(\" + vafs + \"),\\n\\\n\t\t   sampleNames=names[1:\" + x.length + \"]\"\n  if (cn_flag) {\n    z += \",\\n\\\n\t\t   copyNumberCalls=list(\" + copyNumberCalls + \")\"\n  }\n  if ($job.inputs.minimumDepth) {\n    x = $job.inputs.minimumDepth\n    z += \",\\n\\\n\t\t   minimumDepth=\" + x\n  }\n  if ($job.inputs.maximumClusters) {\n    x = $job.inputs.maximumClusters\n    z += \",\\n\\\n\t\t   maximumClusters=\" + x\n  }\n  if ($job.inputs.cnCallsAreLog2) {\n    x = $job.inputs.cnCallsAreLog2\n    z += \",\\n\\\n\t\t   cnCallsAreLog2=\" + String(x).toUpperCase()\n  }\n  if ($job.inputs.useSexChrs) {\n    x = $job.inputs.useSexChrs\n    z += \",\\n\\\n\t\t   useSexChrs=\" + String(x).toUpperCase()\n  }\n  if ($job.inputs.doClustering) {\n    x = $job.inputs.doClustering\n    z += \",\\n\\\n\t\t   doClustering=\" + String(x).toUpperCase()\n  }\n  if ($job.inputs.copyNumberMargins) {\n    x = $job.inputs.copyNumberMargins\n    z += \",\\n\\\n\t\t   copyNumberMargins=\" + x\n  }\n  if ($job.inputs.clusterMethod) {\n    x = $job.inputs.clusterMethod\n    z += \",\\n\\\n\t\t   clusterMethod='\" + x + \"'\"\n  }\n  \n  if (regions_flag) {\n    z += \",\\n\\\n\t\t   regionsToExclude=list(rbind(\" + regionsToExclude + \")));\\n\"\n  } else {\n    z += \");\\n\"\n  }\n  COMMAND += z\n  \n  //produce and plot results\n  x = ordered_vafs\n  s = []\n  for (i=0; i<x.length; i++) {\n    if (x[i].metadata && x[i].metadata.sample_id) {\n      s[i] = x[i].metadata.sample_id\n    } else {\n      s[i] = x[i].path.split('/').pop().split('.')[0]\n    }\n  }\n  if ($job.inputs.output_prefix) {\n    y1 = $job.inputs.output_prefix\n    y2 = $job.inputs.output_prefix\n  } else {\n    y1 = s.join('.')\n    y2 = y1\n  }\n  \n  \n  //add normal_id in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.normal_id) {\n    y1 = x[0].metadata.normal_id + '.' + y1\n    y2 = y2 + '-' + x[0].metadata.normal_id\n  }\n  \n  //add variant_caller in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.variant_caller) {\n    y1 = y1 + '.' + x[0].metadata.variant_caller\n    y2 = y2 + '.' + x[0].metadata.variant_caller\n  }\n  \n  //add reference_handle in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.reference_handle) {\n    y1 = y1 + '.' + x[0].metadata.reference_handle\n    y2 = y2 + '.' + x[0].metadata.reference_handle\n  }\n  \n  if ($job.inputs.output_naming && $job.inputs.output_naming=='Type2') {\n    y = y2\n  } else {\n    y = y1\n  }\n  \n  z = \"writeClusterTable(sc,'\" + y + \".clusters');\\n\"\n  z += \"writeClusterSummaryTable(sc,'\" + y + \".cluster.summary');\\n\"\n  z += \"sc.plot1d(sc,'\" + y + \".clusters_1d.pdf');\\n\"\n  x = ordered_vafs\n  if (x.length>1) {\n    z += \"sc.plot2d(sc,'\" + y + \".clusters_2d.pdf');\\n\"\n    \n    // 3D plotting doesn't work because of docker rendering limitations\n    //if (x.length==3) {\n    //  z += \"sc.plot3d(sc,sc@sampleNames,size=700,outputFile='\" + y + \".clusters_3d.gif');\\n\"\n    //}\n  }\n  COMMAND += z\n  \n  \n  //return whole script\n  return COMMAND\n}",
                  "class": "Expression"
                },
                "filename": "sciClone.R"
              },
              {
                "fileContent": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  //produce and plot results\n  x = [].concat($job.inputs.vafs)\n  s = []\n  for (i=0; i<x.length; i++) {\n    if (x[i].metadata && x[i].metadata.sample_id) {\n      s[i] = x[i].metadata.sample_id\n    } else {\n      s[i] = x[i].path.split('/').pop().split('.')[0]\n    }\n  }\n  if ($job.inputs.output_prefix) {\n    y1 = $job.inputs.output_prefix\n  } else {\n    y1 = s.join('.')\n    y2 = y1\n  }\n  \n  \n  //add normal_id in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.normal_id) {\n    y1 = x[0].metadata.normal_id + '.' + y1\n    y2 = y2 + '-' + x[0].metadata.normal_id\n  }\n  \n  //add variant_caller in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.variant_caller) {\n    y1 = y1 + '.' + x[0].metadata.variant_caller\n    y2 = y2 + '.' + x[0].metadata.variant_caller\n  }\n  \n  //add reference_handle in prefix to output names if it exists\n  if (x[0].metadata && x[0].metadata.reference_handle) {\n    y1 = y1 + '.' + x[0].metadata.reference_handle\n    y2 = y2 + '.' + x[0].metadata.reference_handle\n  }\n  \n  if ($job.inputs.output_naming && $job.inputs.output_naming=='Type2') {\n    y = y2\n  } else {\n    y = y1\n  }\n  \n  var sample_name = y + '.estimated_tumor_purity.txt'\n  return \"tmp1=$(grep 'cluster1 *' \" + y + \".cluster.summary.means | tr -s $'\\\\t' | cut -f 2) && tmp2=$(echo \\\"($tmp1 + $tmp1)*100\\\" | bc -l) && if (( $(echo \\\"$tmp2 > 100\\\" | bc -l) )); then tmp3=\\\"100\\\"; else tmp3=$tmp2; fi && echo 'Estimated sample tumor purity by looking at cluster centroid data is' $tmp3 >> \" + sample_name\n}",
                  "class": "Expression"
                },
                "filename": "calc_purity"
              },
              {
                "fileContent": "bash ./calc_purity",
                "filename": "sh_wrapper.sh"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine",
            "class": "ExpressionEngineRequirement"
          }
        ],
        "inputs": [
          {
            "label": "Variant allele fraction data",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "VAF,DAT,VCF",
            "type": [
              {
                "items": "File",
                "name": "vafs",
                "type": "array"
              }
            ],
            "description": "A list of dataframes containing variant allele fraction data for single nucleotide variants in 5-column format: 1. chromosome 2. position 3.reference-supporting read counts 4. variant-supporting read counts 5. variant allele fraction (between 0-100).",
            "id": "#vafs",
            "sbg:category": "Arguments",
            "required": true
          },
          {
            "label": "Use sex chromosomes",
            "sbg:toolDefaultValue": "TRUE",
            "id": "#useSexChrs",
            "description": "Boolean argument to specify preference of whether or not to use variants on sex chromosomes in the clustering steps of the tool.",
            "type": [
              "null",
              {
                "symbols": [
                  "TRUE",
                  "FALSE"
                ],
                "name": "useSexChrs",
                "type": "enum"
              }
            ],
            "sbg:category": "Arguments",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "label": "Sample order",
            "sbg:toolDefaultValue": "Alphabetical order",
            "id": "#sample_order",
            "description": "List here the order of the sequenced samples, by adding string values of sample IDs (or VCF filenames) in their chronological order (if you add filenames, the sample IDs must be contained in their respective filenames). There should be as much as rows as there are samples/VCFs used in the sciClone analysis. This is important for downstream analysis with tools like Fishplot, which are used to infer the evolution of the tumor. If only one sample is being processed with sciClone, this input is not needed. If multiple sample are being processed, but this input is not provided (or the number of samples specified is not the as the number of input samples), the samples will be sorted alphabetically.",
            "type": [
              "null",
              {
                "items": "string",
                "type": "array"
              }
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Regions to be excluded",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "LOH,TXT",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "Exclusions of regions in 3-column format: 1. chromosome 2. window star position 3. window stop position. Single nucleotide variants falling into these windows will not be included in the analysis. Use this input for LOH regions for example.",
            "id": "#regionsToExclude",
            "sbg:category": "Arguments",
            "required": false
          },
          {
            "label": "Output prefix",
            "sbg:toolDefaultValue": "Inferred from metadata",
            "id": "#output_prefix",
            "description": "Output prefix to be added on all output files.",
            "type": [
              "null",
              "string"
            ],
            "sbg:category": "Arguments"
          },
          {
            "label": "Output naming",
            "sbg:toolDefaultValue": "Type1",
            "id": "#output_naming",
            "description": "Output naming convention. Type1: normal.tumor; Type2: tumor-normal.",
            "type": [
              "null",
              {
                "symbols": [
                  "Type1",
                  "Type2"
                ],
                "name": "output_naming",
                "type": "enum"
              }
            ],
            "sbg:category": "Arguments",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "label": "Minimum depth",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "100",
            "type": [
              "null",
              "int"
            ],
            "description": "Threshold used for excluding low-depth variants.",
            "id": "#minimumDepth",
            "sbg:category": "Arguments",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "label": "Maximum clusters",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "10",
            "type": [
              "null",
              "int"
            ],
            "description": "Max number for clusters to consider when choosing the component fit to the data.",
            "id": "#maximumClusters",
            "sbg:category": "Arguments",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "label": "Do clustering",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "TRUE",
            "type": [
              "null",
              {
                "symbols": [
                  "TRUE",
                  "FALSE"
                ],
                "name": "doClustering",
                "type": "enum"
              }
            ],
            "description": "If TRUE, the tool will attempt to use clustering to identify subclones. If FALSE, this stage is skipped and an object suitable for feeding into the plotting functions is produced.",
            "id": "#doClustering",
            "sbg:category": "Arguments"
          },
          {
            "label": "Copy Number Margins",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "0.25",
            "type": [
              "null",
              "float"
            ],
            "description": "In order to identify cleanly copy-number neutral regions, sciClone only considers sites with a copy number of 2.0 +/- this value. For example, if set to 0.25 (which is the default value), regions at 2.20 will be considered cn-neutral and regions at 2.30 will be not.",
            "id": "#copyNumberMargins",
            "sbg:category": "Arguments",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "label": "Copy number segments",
            "sbg:stageInput": "link",
            "sbg:fileTypes": "CNV,CNS,TXT",
            "type": [
              "null",
              {
                "items": "File",
                "name": "copyNumberCalls",
                "type": "array"
              }
            ],
            "description": "A list of dataframes containing copy number segments in 4-column format: 1. chromosome 2. segment start position 3. segment stop position 4. copy number value for that segment. Unrepresented regions are assumed to have a copy number of 2.",
            "id": "#copyNumberCalls",
            "sbg:category": "Arguments",
            "required": false
          },
          {
            "label": "Copy numbers in log2 format",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "False",
            "type": [
              "null",
              "boolean"
            ],
            "description": "Boolean argument specifying whether or not the copy number predictions are in log2 format (as opposed to being absolute copy number designations).",
            "id": "#cnCallsAreLog2",
            "sbg:category": "Arguments"
          },
          {
            "label": "Cluster method",
            "sbg:stageInput": null,
            "sbg:toolDefaultValue": "bmm",
            "type": [
              "null",
              {
                "symbols": [
                  "bmm",
                  "gaussian.bmm",
                  "binomial.bmm"
                ],
                "name": "clusterMethod",
                "type": "enum"
              }
            ],
            "description": "Use a different distribution for clustering. Currently supported options are 'bmm' for beta, 'gaussian.bmm' for gaussian and 'binomial.bmm' for binomial.",
            "id": "#clusterMethod",
            "sbg:category": "Arguments"
          }
        ],
        "outputs": [
          {
            "label": "Plots",
            "sbg:fileTypes": "PDF,GIF",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "Plots containing sub-clonality informations.",
            "id": "#sciclone_plots",
            "outputBinding": {
              "glob": "{*.pdf,*.gif}",
              "sbg:inheritMetadataFrom": "#vafs"
            }
          },
          {
            "label": "Estimated tumor purity",
            "sbg:fileTypes": "TXT",
            "type": [
              "null",
              "File"
            ],
            "description": "Estimated tumor purity for the sample. The estimation is done by analyzing peaks in the kernel density of the main cluster (the one around 50%) and then multiplying that value by two. This output is produced if only one sample is provided to sciClone. If you have multiple samples, please look at the Tumor Heterogeneity report produced by the SBG SciClone Report tool.",
            "id": "#purity",
            "outputBinding": {
              "glob": "*purity.txt",
              "sbg:inheritMetadataFrom": "#vafs"
            }
          },
          {
            "label": "Clusters",
            "sbg:fileTypes": "TXT,CLUSTERS",
            "type": [
              "null",
              "File"
            ],
            "description": "File containing clusters information.",
            "id": "#clusters",
            "outputBinding": {
              "glob": "*clusters",
              "sbg:inheritMetadataFrom": "#vafs",
              "sbg:metadata": {
                "number_of_samples": {
                  "engine": "#cwl-js-engine",
                  "script": "{\n  var x = [].concat($job.inputs.vafs).length\n  return x\n}",
                  "class": "Expression"
                }
              }
            }
          },
          {
            "label": "Cluster summaries",
            "sbg:fileTypes": "TXT,SUMMARY",
            "type": [
              "null",
              {
                "items": "File",
                "type": "array"
              }
            ],
            "description": "Cluster summaries (cluster centers).",
            "id": "#clusterSummary",
            "outputBinding": {
              "glob": "*summary*",
              "sbg:inheritMetadataFrom": "#vafs"
            }
          }
        ],
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerImageId": "",
            "dockerPull": "images.sbgenomics.com/uros_sipetic/sciclone:1.1",
            "class": "DockerRequirement"
          },
          {
            "value": "{sciClone.R,*.log}",
            "class": "sbg:SaveLogs"
          }
        ],
        "baseCommand": [
          "Rscript",
          "--vanilla",
          "sciClone.R",
          ">",
          "sciClone.err.log"
        ],
        "stdin": "",
        "stdout": "",
        "successCodes": [],
        "temporaryFailCodes": [],
        "arguments": [
          {
            "position": 10,
            "separate": true,
            "valueFrom": {
              "engine": "#cwl-js-engine",
              "script": "{\n  if ([].concat($job.inputs.vafs).length==1) {\n\treturn \"&& chmod +x sh_wrapper.sh && chmod +x calc_purity && ./sh_wrapper.sh\"\n  }\n}",
              "class": "Expression"
            }
          }
        ],
        "sbg:toolkitVersion": "1.1",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "regionsToExclude": [
              {
                "path": "/path/to/sample1.exclude.txt",
                "size": 0,
                "secondaryFiles": [],
                "class": "File",
                "metadata": {
                  "sample_id": "Sample1"
                }
              },
              {
                "path": "/path/to/sample2.exclude.txt",
                "size": 0,
                "secondaryFiles": [],
                "class": "File",
                "metadata": {
                  "sample_id": "Sample2"
                }
              },
              {
                "path": "/path/to/sample1.loh.txt",
                "size": 0,
                "secondaryFiles": [],
                "class": "File",
                "metadata": {
                  "sample_id": "Sample1"
                }
              },
              {
                "path": "/path/to/sample2.loh.txt",
                "size": 0,
                "secondaryFiles": [],
                "class": "File",
                "metadata": {
                  "sample_id": "Sample2"
                }
              }
            ],
            "copyNumberMargins": null,
            "maximumClusters": null,
            "sample_order": null,
            "output_prefix": "",
            "clusterMethod": "binomial.bmm",
            "useSexChrs": null,
            "cnCallsAreLog2": false,
            "output_naming": null,
            "vafs": [
              {
                "path": "/path/to/Sample2.vafs.ext",
                "size": 0,
                "metadata": {
                  "normal_id": "Normal",
                  "sample_id": "Sample2",
                  "variant_caller": "Strelka",
                  "reference_handle": "hg19"
                },
                "secondaryFiles": [],
                "class": "File"
              },
              {
                "path": "/path/to/Sample1.vafs.ext",
                "class": "File",
                "size": 0,
                "secondaryFiles": [],
                "metadata": {
                  "sample_id": "Sample2",
                  "normal_id": "Normal",
                  "variant_caller": "Strelka",
                  "reference_handle": "hg19"
                }
              }
            ],
            "copyNumberCalls": [
              {
                "path": "/path/to/sample1.cnvs.ext",
                "size": 0,
                "metadata": {
                  "sample_id": "Sample1"
                },
                "secondaryFiles": [],
                "class": "File"
              },
              {
                "path": "/path/to/sample2.cnvs.ext",
                "class": "File",
                "size": 0,
                "secondaryFiles": [],
                "metadata": {
                  "sample_id": "Sample2"
                }
              }
            ],
            "doClustering": null,
            "minimumDepth": 80
          }
        },
        "sbg:toolkit": "SciClone",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://www.biostars.org/t/sciclone/"
          },
          {
            "label": "Source Code",
            "id": "https://github.com/genome/sciclone"
          },
          {
            "label": "Download",
            "id": "https://github.com/genome/sciclone/archive/1.1.tar.gz"
          },
          {
            "label": "Publication",
            "id": "http://www.ncbi.nlm.nih.gov/pmc/articles/PMC4125065/"
          },
          {
            "label": "Documentation",
            "id": "https://github.com/genome/sciclone/blob/master/man/sciClone.Rd"
          }
        ],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "sbg:toolAuthor": "Christopher A. Miller, Brian S. White, Nathan D. Dees, John S. Welch, Malachi Griffith, Obi Griffith, Ravi Vij, Michael H. Tomasson, Timothy A. Graubert, Matthew J. Walter, William Schierding, Timothy J. Ley, John F. DiPersio, Elaine R. Mardis, Richard K. Wilson, and Li Ding",
        "sbg:categories": [
          "Tumor-heterogeneity",
          "Tumor-sub-clonality"
        ],
        "sbg:license": "Apache License 2.0",
        "sbg:image_url": null,
        "sbg:cmdPreview": "Rscript --vanilla sciClone.R > sciClone.err.log",
        "sbg:projectName": "SciClone 1.1 - Demo",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1473774679,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1/sciclone-1-1/33"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1473846476,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1/sciclone-1-1/34"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1473848358,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1/sciclone-1-1/35"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1473848949,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1/sciclone-1-1/36"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1473870296,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1/sciclone-1-1/37"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1478616745,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1480511332,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485533808,
            "sbg:revisionNotes": "Fix boolean parameters with default True values."
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485950414,
            "sbg:revisionNotes": "Stage regionsToExclude input."
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485952823,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485955194,
            "sbg:revisionNotes": "Add purity estimation."
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485957576,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1485959404,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486039575,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486044713,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486045829,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486046529,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486052585,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486056017,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486063432,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1486492364,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1495822291,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1495824899,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1496318436,
            "sbg:revisionNotes": "Re-do purity calculation wrapper."
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1496320397,
            "sbg:revisionNotes": "Update purity calculation."
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1497114923,
            "sbg:revisionNotes": "Add changes to prepare sciClone for outputting tumor_information.txt file. \nActual script still needs to be implemented. TryCatch() mechanisms also needs to be implemented."
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1497546885,
            "sbg:revisionNotes": "Make sure CNV and VAF files are properly paired."
          },
          {
            "sbg:revision": 27,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498055460,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 28,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498057151,
            "sbg:revisionNotes": "Add automatic CNV column recognizing for CNVkit."
          },
          {
            "sbg:revision": 29,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498059174,
            "sbg:revisionNotes": "Make proper CNVkit cns file parsing."
          },
          {
            "sbg:revision": 30,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498481646,
            "sbg:revisionNotes": "Make CNV Caller an enum parameter."
          },
          {
            "sbg:revision": 31,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1498566264,
            "sbg:revisionNotes": "Remove sciClone's method of estimating tumor purity."
          },
          {
            "sbg:revision": 32,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1507653321,
            "sbg:revisionNotes": "Add option for output file renaming."
          },
          {
            "sbg:revision": 33,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509546102,
            "sbg:revisionNotes": "Outputs prefixed by all sample_ids"
          },
          {
            "sbg:revision": 34,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509563024,
            "sbg:revisionNotes": "Add variant caller in output file names if variant_caller metadata exists"
          },
          {
            "sbg:revision": 35,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509650520,
            "sbg:revisionNotes": "Update glob"
          },
          {
            "sbg:revision": 36,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1509666277,
            "sbg:revisionNotes": "Update purity file name"
          },
          {
            "sbg:revision": 37,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511309331,
            "sbg:revisionNotes": "Add stdout.log as an output log using sbg:SaveHints"
          },
          {
            "sbg:revision": 38,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511314509,
            "sbg:revisionNotes": "Redirect both stdout and stderr to an output_log"
          },
          {
            "sbg:revision": 39,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511316301,
            "sbg:revisionNotes": "Remove stdout_lot"
          },
          {
            "sbg:revision": 40,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511386754,
            "sbg:revisionNotes": "Add additional input for sorting VAF files by chronological order."
          },
          {
            "sbg:revision": 41,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511388239,
            "sbg:revisionNotes": "Produce purity file only for one sample."
          },
          {
            "sbg:revision": 42,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511389361,
            "sbg:revisionNotes": "Fix typos in description."
          },
          {
            "sbg:revision": 43,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511477740,
            "sbg:revisionNotes": "Fix error in sorting vafs chronologically."
          },
          {
            "sbg:revision": 44,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1516960815,
            "sbg:revisionNotes": "Add 'number_of_samples' metadata on the '*.clusters' output file."
          },
          {
            "sbg:revision": 45,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1522684552,
            "sbg:revisionNotes": "Parse CNVkit CNV file based on the \"cn\" column, instead of fixed column 9"
          },
          {
            "sbg:revision": 46,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526892361,
            "sbg:revisionNotes": "Add sciClone.err.log to log outputs"
          },
          {
            "sbg:revision": 47,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526932057,
            "sbg:revisionNotes": "Comment out 3D plotting"
          },
          {
            "sbg:revision": 48,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528140255,
            "sbg:revisionNotes": "Add flattening of regions input"
          },
          {
            "sbg:revision": 49,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528198328,
            "sbg:revisionNotes": "Update bug in sciClone tool related to properly utilizing all regions to exclude."
          },
          {
            "sbg:revision": 50,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528986059,
            "sbg:revisionNotes": "Fix bug with flattened regions"
          },
          {
            "sbg:revision": 51,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1533916494,
            "sbg:revisionNotes": "Update output naming options"
          },
          {
            "sbg:revision": 52,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1534185556,
            "sbg:revisionNotes": "small typo in desc"
          },
          {
            "sbg:revision": 53,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548428422,
            "sbg:revisionNotes": "Sort regions to exclude by their respective samples"
          },
          {
            "sbg:revision": 54,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548783474,
            "sbg:revisionNotes": "Update save.logs"
          },
          {
            "sbg:revision": 55,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1548787401,
            "sbg:revisionNotes": "Update savelogs"
          },
          {
            "sbg:revision": 56,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1560777241,
            "sbg:revisionNotes": "Fix CNV expression"
          },
          {
            "sbg:revision": 57,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565339556,
            "sbg:revisionNotes": "Update description"
          },
          {
            "sbg:revision": 58,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565623914,
            "sbg:revisionNotes": "Remove choosing the CNV caller form sciClone (CNV converter should take care of this from now on)."
          },
          {
            "sbg:revision": 59,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565630316,
            "sbg:revisionNotes": "Flatten CNV input"
          }
        ],
        "cwlVersion": "sbg:draft-2",
        "abg:revisionNotes": "Update output naming options",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "uros_sipetic/sciclone-1-1-demo/sciclone-1-1/59",
        "sbg:id": "uros_sipetic/sciclone-1-1-demo/sciclone-1-1/59",
        "sbg:revision": 59,
        "sbg:revisionNotes": "Flatten CNV input",
        "sbg:modifiedOn": 1565630316,
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:createdOn": 1473774679,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "uros_sipetic/sciclone-1-1-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "sbg:latestRevision": 59,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "af73c93d3a34b8c344f15785622612c7e4060ec5d6da109540650174ecf3bd400",
        "x": 1162.5000912745763,
        "y": 310.98485504296457
      },
      "inputs": [
        {
          "id": "#SciClone_1_1.vafs",
          "source": [
            "#SBG_SciClone_VCF_parser.vafs"
          ]
        },
        {
          "id": "#SciClone_1_1.useSexChrs",
          "source": [
            "#useSexChrs"
          ]
        },
        {
          "id": "#SciClone_1_1.sample_order",
          "source": [
            "#sample_order"
          ]
        },
        {
          "id": "#SciClone_1_1.regionsToExclude",
          "source": [
            "#SBG_Get_LOH_Regions.output_file",
            "#SBG_SciClone_VCF_parser.regions_to_exclude"
          ]
        },
        {
          "id": "#SciClone_1_1.output_prefix"
        },
        {
          "id": "#SciClone_1_1.output_naming",
          "source": [
            "#output_naming"
          ]
        },
        {
          "id": "#SciClone_1_1.minimumDepth",
          "source": [
            "#SBG_SciClone_Parameters.read_depth"
          ]
        },
        {
          "id": "#SciClone_1_1.maximumClusters",
          "source": [
            "#SBG_SciClone_Parameters.max_clust"
          ]
        },
        {
          "id": "#SciClone_1_1.doClustering"
        },
        {
          "id": "#SciClone_1_1.copyNumberMargins",
          "source": [
            "#copyNumberMargins"
          ]
        },
        {
          "id": "#SciClone_1_1.copyNumberCalls",
          "source": [
            "#SBG_CNV_Converter.converted_files"
          ]
        },
        {
          "id": "#SciClone_1_1.cnCallsAreLog2",
          "source": [
            "#cnCallsAreLog2"
          ]
        },
        {
          "id": "#SciClone_1_1.clusterMethod",
          "default": "binomial.bmm",
          "source": [
            "#clusterMethod"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SciClone_1_1.sciclone_plots"
        },
        {
          "id": "#SciClone_1_1.purity"
        },
        {
          "id": "#SciClone_1_1.clusters"
        },
        {
          "id": "#SciClone_1_1.clusterSummary"
        }
      ],
      "sbg:x": 1162.5000912745763,
      "sbg:y": 310.98485504296457
    },
    {
      "id": "#SBG_SciClone_Parameters",
      "run": {
        "class": "CommandLineTool",
        "label": "SBG SciClone Parameters",
        "description": "\"SBG SciClone parameter\" is a fail prevention tool for the SciClone tool.\n\nFiles that have too few VAFs that comply with the limits by which SciClone filters them can cause the tool to fail as no clusters can be made.\nIn order to prevent this, \"SciClone parameter\" tool filters the VAFs in the same way as the SciClone tool itself, and if requirements for the number of clusters are not met, it lowers the cutoff parameters so more VAFs are analyzed. The process is repeated until satisfying parameters are achieved.\n\nThe parameters calculated with this tool are then sent to SciClone, ensuring that it will not fail.",
        "requirements": [
          {
            "fileDef": [
              {
                "fileContent": "\"\"\"\nScript that check the input parameters for SciClone tool and sets them\nso that SciClone tool will not fail duo to a too few clusters.\n\"\"\"\nimport argparse\nimport csv\n\nfrom Classes import SciDict, Range\nfrom utils import modify_read_depth\n\nparser = argparse.ArgumentParser(\n    description='Calculate optimal setting for SciClone')\n\nparser.add_argument(\n    '-vaf',\n    '--vaf_file',\n    help='Input VAF file',\n    required=True\n)\n\nparser.add_argument(\n    '-cnv',\n    '--cnv_file',\n    help='Input CNV file',\n    default='skip'\n)\n\nparser.add_argument(\n    '-sex',\n    '--use_sex',\n    help='Use sex chromosome',\n    default=False,\n    type=bool\n)\n\nparser.add_argument(\n    '-regions',\n    '--regions_file',\n    help='Input file with regions to exclude',\n    required=True\n)\n\nparser.add_argument(\n    '-max_clust',\n    help='Number of clusters',\n    default=10,\n    type=int\n)\n\nparser.add_argument(\n    '-read_depth',\n    help='Read depth',\n    default=80,\n    type=int\n)\n\nparser.add_argument(\n    '-cnv_thresh',\n    help='CNV threshold tolerance',\n    default=0.25,\n    type=float\n)\n\nparser.add_argument(\n    '-rd_res',\n    help='Read depth resolution',\n    default=10,\n    type=int\n)\n\nparser.add_argument(\n    '-cnv_type',\n    help='Summary upper path',\n    default=2,\n    type=int\n)\n\nargs = parser.parse_args()\nranges_file = args.regions_file.split(',')\nvafs_file = args.vaf_file.split(',')\ncnv_file = args.cnv_file.split(',')\ncnv_thresh = args.cnv_thresh\ncnv_type = args.cnv_type\ninput_max_clusters = args.max_clust\ninput_rdr = args.rd_res\ninput_read_depth = args.read_depth\nuse_sex = args.use_sex\n\noutput_max_clusters = []\noutput_read_depth = []\nranges = []\n# Load ranges\nranges_dict = {}\nfor file in ranges_file:\n    ranges.append(csv.reader(open(file, 'r'), delimiter='\\t'))\n\nfor file in ranges:\n    for line in file:\n        if line[0] not in ranges_dict:\n            ranges_dict[line[0]] = []\n            ranges_dict[line[0]].append(Range(line[1], line[2]))\n        else:\n            ranges_dict[line[0]].append(Range(line[1], line[2]))\nvafs_dicts = []\nfor file_num, file in enumerate(vafs_file):\n\n    vafs = csv.reader(open(vafs_file[file_num], 'r'), delimiter='\\t')\n\n    vafs_dict = SciDict()\n\n    # Load VAFs\n    for line in vafs:\n        vafs_dict[line[0]] = line\n    if use_sex:\n        keys_to_del = []\n        for key in vafs_dict:\n            if key.lower() in [\"x\", \"y\", \"chrx\", \"chry\"]:\n                keys_to_del.append(key)\n        for key in keys_to_del:\n            del vafs_dict[key]\n\n    # Filter by CNV\n    if cnv_file[file_num] != \"skip\":\n        cnvs = csv.reader(open(cnv_file[file_num], 'r'), delimiter='\\t')\n\n        cnv_dict = {}\n        passed_header = False\n        for line in cnvs:\n            if line[0][0] != \"#\":\n                if line[0] not in cnv_dict:\n                    cnv_dict[line[0]] = []\n                    cnv_dict[line[0]].append(line)\n                    if not passed_header:\n                        cnv_header_key = line[0]\n                        passed_header = True\n                else:\n                    cnv_dict[line[0]].append(line)\n\n        cnv_header = cnv_dict[cnv_header_key][0]\n        del cnv_dict[cnv_header_key]\n\n        #set proper CN columns - old version was to choose from an enum; new version it's always column3\n        #if cnv_type == 1:\n        #    cnv_col = 3\n        #elif cnv_type == 2:\n        #    cnv_col = cnv_header.index(\"cn\")\n        cnv_col = 3\n\n        for key in cnv_dict:\n            if key in vafs_dict:\n                for cnv in cnv_dict[key]:\n                    cond = float(cnv[cnv_col]) != 2.0\n                    positions = vafs_dict.get_positions(key)\n                    for pos in positions:\n                        if int(cnv[1]) <= int(vafs_dict[(key, pos)][0][1]\n                                              ) <= int(cnv[2]) and cond:\n                            del vafs_dict[(key, pos)]\n\n    # Filter out VAFs\n    for key in vafs_dict:\n        if key in ranges_dict:\n            for _range in ranges_dict[key]:\n                positions = vafs_dict.get_positions(key)\n                for pos in positions:\n                    if _range.is_in_range(pos):\n                        del vafs_dict[(key, pos)]\n    vafs_dicts.append(vafs_dict)\n# Merge vafs\nprint(\"Merge VAFs\")\nvafs_dict_merged = SciDict()\nnum_of_samples = len(vafs_file)\n\nfor vd in vafs_dicts:\n    for key in vd:\n        for item in vd[key]:\n            vafs_dict_merged[key] = item\n\nto_del = []\nprint(vafs_dict_merged)\nfor key in vafs_dict_merged:\n    for pos in vafs_dict_merged.get_positions(key):\n        if len(vafs_dict_merged[(key, pos)]) < num_of_samples:\n            to_del.append((key, pos))\nfor item in to_del:\n    del vafs_dict_merged[item]\n\n\ndel to_del\n# Set new read depth and max clusters\nnew_read_depth = modify_read_depth(vafs_dict_merged, input_rdr,\n                                   input_read_depth, input_max_clusters,\n                                   num_of_samples)\nnew_max_clusters = input_max_clusters\n\nwhile new_read_depth <= 1 < new_max_clusters:\n    new_max_clusters -= 1\n    new_read_depth = modify_read_depth(vafs_dict_merged, input_rdr,\n                                       input_read_depth, new_max_clusters,\n                                       num_of_samples)\n\n\n\nopen(str(new_max_clusters) + \".maxclust\", 'a').close()\nopen(str(new_read_depth) + \".readdepth\", 'a').close()",
                "filename": "parameters.py"
              },
              {
                "fileContent": "class SciDict(dict):\n\n    def __getitem__(self, item):\n        if isinstance(item, tuple):\n            return self.__dict__[item[0]][item[1]]\n        else:\n            to_return = []\n            for key in self.__dict__[item]:\n                for elem in self.__dict__[item][key]:\n                    to_return.append(elem)\n            return to_return\n\n    def __setitem__(self, key, value):\n        if key in self.__dict__:\n            if value[1] in self.__dict__[key]:\n                self.__dict__[key][value[1]].append(value)\n            else:\n                self.__dict__[key][value[1]] = []\n                self.__dict__[key][value[1]].append(value)\n        else:\n            self.__dict__[key] = {}\n            self.__dict__[key][value[1]] = []\n            self.__dict__[key][value[1]].append(value)\n\n    def __contains__(self, item):\n        if item in self.__dict__:\n            return True\n        return False\n\n    def keys(self):\n        return self.__dict__.keys()\n\n    def __iter__(self):\n        for x in self.__dict__:\n            yield x\n\n    def __delitem__(self, item):\n        if isinstance(item, tuple):\n            del self.__dict__[item[0]][item[1]]\n        else:\n            del self.__dict__[item]\n\n    def get_positions(self, key):\n        return list(self.__dict__[key].keys())\n\n\nclass Range:\n    \"\"\"\n    Class that stores ranges so numbers can be easily compared to them\n    \"\"\"\n\n    def __init__(self, _val1, _val2):\n        \"\"\"\n        Constructor of the Range class.\n        Arranges values form smaller to larger.\n        :param _val1: Value of one of the borders of the range.\n        :param _val2: Value of one of the borders of the range.\n        \"\"\"\n        v1 = int(_val1)\n        v2 = int(_val2)\n        if v1 > v2:\n            self.range_from = v2\n            self.range_to = v1\n        else:\n            self.range_to = v2\n            self.range_from = v1\n\n    def is_in_range(self, _to_cmp):\n        \"\"\"\n        Method that determines if the input value is inside the range.\n        :param _to_cmp: Value to be compared.\n        :return: True if _to_cmp inside the range, False otherwise.\n        \"\"\"\n        return bool(self.range_from <= int(_to_cmp) <= self.range_to)",
                "filename": "Classes.py"
              },
              {
                "fileContent": "import copy\n\n\ndef modify_read_depth(_vaf, _rdr, _ird, _imc, no_of_samples):\n    \"\"\"\n    Function that determines the minimum value of read depth so that\n    the number of clusters can be maintained.\n    :param _vaf: Dictionary with all vaf values, keyed by contigs.\n    :param _rdr: Value by which the read depth will be reduced\n                 in every iteration. (read depth resolution)\n    :param _ird: Starting read depth. (input read depth)\n    :param _imc: Number of clusters to be maintained. (input max clusters)\n    :return: The new value of read depth.\n    \"\"\"\n    number_of_vafs = 0\n    _new_read_depth = _ird\n    while number_of_vafs < (_imc + 1) and (_new_read_depth + _rdr) > 0:\n        vaf_clone = copy.deepcopy(_vaf)\n        for contig in vaf_clone:\n            positions = vaf_clone.get_positions(contig)\n            for pos in positions:\n                delete = False\n                for elem in vaf_clone[(contig, pos)]:\n                    if int(elem[2]) + int(elem[3]) < _new_read_depth:\n                        delete = True\n                        break\n                if delete:\n                    del vaf_clone[(contig, pos)]\n\n        number_of_vafs = count_dict(vaf_clone) / no_of_samples\n        _new_read_depth -= _rdr\n    _new_read_depth += _rdr\n\n    return int(_new_read_depth)\n\n\ndef count_dict(_input_dict):\n    \"\"\"\n    Function that returns the sum of elements in dictionary fields\n    :param _input_dict: Dictionary to be counted.\n    :return: number of elements in the dictionary.\n    \"\"\"\n    count = 0\n    for _key in _input_dict:\n        count += len(_input_dict[_key])\n    return count",
                "filename": "utils.py"
              }
            ],
            "class": "CreateFileRequirement"
          },
          {
            "class": "ExpressionEngineRequirement",
            "requirements": [
              {
                "dockerPull": "rabix/js-engine",
                "class": "DockerRequirement"
              }
            ],
            "id": "#cwl-js-engine"
          }
        ],
        "inputs": [
          {
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "TRUE",
                  "FALSE"
                ],
                "name": "use_sex"
              }
            ],
            "label": "Use sex chromosomes",
            "sbg:toolDefaultValue": "False",
            "inputBinding": {
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if ($job.inputs.use_sex) {\n    if ($job.inputs.use_sex == \"TRUE\") {\n      return \"--use_sex 1\"\n    } else { \n      return \"\"\n    } \n  } else { \n    return \"--use_sex 1\"\n  }\n}"
              },
              "separate": false,
              "position": 55,
              "sbg:cmdInclude": true
            },
            "id": "#use_sex",
            "description": "Use sex chromosomes in the clustering.",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "type": [
              "null",
              "int"
            ],
            "label": "Read depth resolution",
            "id": "#read_resolution",
            "inputBinding": {
              "prefix": "-rd_res",
              "separate": true,
              "position": 35,
              "sbg:cmdInclude": true
            },
            "description": "Amount by which read required read depth will be lowered in each cycle in order to optimize the parameters.",
            "sbg:category": "Settings"
          },
          {
            "type": [
              {
                "items": "File",
                "type": "array"
              }
            ],
            "label": "Input VAF file",
            "id": "#input_vaf",
            "inputBinding": {
              "prefix": "-vaf",
              "itemSeparator": ",",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "description": "FIle containing VAFs.",
            "sbg:category": "Input",
            "required": true
          },
          {
            "type": [
              {
                "items": "File",
                "type": "array"
              }
            ],
            "label": "Regions file",
            "id": "#input_regions",
            "inputBinding": {
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  function flatten(files){\n    var a = []\n  \tfor(var i=0;i<files.length;i++){\n      if(files[i]){\n        if(files[i].constructor == Array) {\n          a = a.concat(flatten(files[i]))\n        } else {\n          a = a.concat(files[i])\n        }\n      }\n    }\n    return a\n  }\n  \n  arr = [].concat($job.inputs.input_regions)\n  regions = []\n  regions = flatten(arr)\n  paths = []\n  for (i=0; i<regions.length; i++) {\n    paths = paths.concat(regions[i].path)\n  }\n  return paths.join(',')\n}"
              },
              "separate": true,
              "prefix": "-regions",
              "itemSeparator": ",",
              "position": 10,
              "sbg:cmdInclude": true
            },
            "description": "File containing regions to be excluded from analysis.",
            "sbg:category": "Input",
            "required": true
          },
          {
            "type": [
              "null",
              "int"
            ],
            "label": "Read depth cutoff",
            "description": "Minimum read depth required to pass the filter.",
            "sbg:toolDefaultValue": "80",
            "inputBinding": {
              "prefix": "-read_depth",
              "separate": true,
              "position": 25,
              "sbg:cmdInclude": true
            },
            "id": "#input_read_depth",
            "sbg:category": "Settings"
          },
          {
            "type": [
              "null",
              "int"
            ],
            "label": "Number of clusters",
            "description": "The number of clusters that SciClone needs to be able to achieve.",
            "sbg:toolDefaultValue": "10",
            "inputBinding": {
              "prefix": "-max_clust",
              "separate": true,
              "position": 20,
              "sbg:cmdInclude": true
            },
            "id": "#input_max_clust",
            "sbg:category": "Settings"
          },
          {
            "type": [
              "null",
              "float"
            ],
            "label": "CNV tolerance",
            "description": "Tolerance of CNV diverging from \"2\".",
            "sbg:toolDefaultValue": "0.25",
            "inputBinding": {
              "prefix": "-cnv_thresh",
              "separate": true,
              "position": 30,
              "sbg:cmdInclude": true
            },
            "id": "#input_cnv_tresh",
            "sbg:category": "Settings",
            "sbg:includeInPorts": true,
            "required": false
          },
          {
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "label": "CNV file",
            "id": "#input_cnv",
            "inputBinding": {
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  function flatten(files){\n    var a = []\n  \tfor(var i=0;i<files.length;i++){\n      if(files[i]){\n        if(files[i].constructor == Array) {\n          a = a.concat(flatten(files[i]))\n        } else {\n          a = a.concat(files[i])\n        }\n      }\n    }\n    return a\n  }\n  \n  \n  var tmp = [].concat($job.inputs.input_cnv)\n  var x = []\n  x = flatten(tmp)\n  var cnvs = x\n  if (cnvs[0] && cnvs[0].path) {\n    if($job.inputs.input_vaf.length != 1){\n      // check if all files have metadata\n      vaf_meta_count=0\n      cnv_meta_count=0\n      for(i=0;i<$job.inputs.input_vaf.length;i++){\n        if($job.inputs.input_vaf[i].metadata){ vaf_meta_count++}\n      }\n      for(i=0;i<cnvs.length;i++){\n        if(cnvs[i].metadata){ cnv_meta_count++}\n      }\n    \n      if($job.inputs.input_vaf.length == vaf_meta_count && cnvs.length == cnv_meta_count){\n        use_metadata = true\n      }else{\n        use_metadata = false\n      }\n\n      num_of_files = $job.inputs.input_vaf.length\n      /////////////////////////////////////\n      //If all files have metadata, it will be used to sort paths.\n      //If not then file names will be used\n      \n      //create array of skips\n      if(use_metadata){\n        output = \"\"\n        for(i=0;i<num_of_files-1;i++){output = output + \"skip,\"}\n        output = output + \"skip\"\n        //end\n        //splitting into separate elements\n        output = output.split(\",\")\n        //end\n\n        for(i=0;i<num_of_files;i++){\n          for(j=0;j<cnvs.length;j++){\n            if (cnvs[j].metadata.sample_id == $job.inputs.input_vaf[i].metadata.sample_id){\n              output[i]= cnvs[j].path\n            }\n          }\n        }\n\t    return \"-cnv \" + output.join(\",\")\n      }\n\n      /////////////////////////////////////////\n      //Else use names\n  \n      else {\n       output = \"\"\n       vaf_files = \"\"\n       cnv_files = \"\"\n    \n       for(i=0;i<num_of_files-1;i++){\n         output = output + \"skip,\"\n         vaf_files = vaf_files + \"temp,\"\n         cnv_files = cnv_files + \"temp,\"\n       }\n       output = output + \"skip\"\n       vaf_files = vaf_files + \"temp\"\n       cnv_files = cnv_files + \"temp\"\n       //end\n\n\n       //splitting into separate elements\n       vaf_files = vaf_files.split(\",\")\n       cnv_files = cnv_files.split(\",\")\n       output = output.split(\",\")\n       //end\n       for(i=0;i<$job.inputs.input_vaf.length;i++){ \n         base=$job.inputs.input_vaf[i].path\n         filename_full = base.split(\"/\")[base.split(\"/\").length - 1]\n         vaf_files[i] =  filename_full.split(\".\")[0]\n       }\n  \n       for(i=0;i<cnvs.length;i++){ \n         base=cnvs[i].path\n         filename_full = base.split(\"/\")[base.split(\"/\").length - 1]\n         cnv_files[i] =  filename_full.split(\".\")[0]\n       }\n\n\n       for(i=0;i<num_of_files;i++){\n\t     for(j=0;j<cnvs.length;j++){\n  \t\t   if (cnv_files[j] == vaf_files[i]){\n    \t     output[i]= cnvs[j].path\n    \t   }\n         }\n       }\n       return \"-cnv \" + output.join(\",\")\n      }\n    }\n  \n    else {\n      if($job.inputs.input_cnv) {\n        return \"-cnv \" + cnvs[0].path\n      }\n      else {\n        return \"\"\n      }\n    }\n  }\n}"
              },
              "sbg:cmdInclude": true,
              "itemSeparator": ",",
              "position": 15,
              "separate": true
            },
            "description": "File containing CNV data by which the VAFs are to be filtered.",
            "sbg:category": "Input",
            "required": false
          },
          {
            "type": [
              "null",
              {
                "type": "enum",
                "name": "cnv_caller",
                "symbols": [
                  "Control-FREEC",
                  "CNVkit"
                ]
              }
            ],
            "label": "CNV caller",
            "description": "Declare which tool created the CNV file.",
            "sbg:toolDefaultValue": "CNV Kit",
            "inputBinding": {
              "valueFrom": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  if($job.inputs.cnv_caller == \"Control-FREEC\"){ \n    return 1\n  } else if($job.inputs.cnv_type == \"CNVkit\"){ \n    return 2 \n  } else {\n    return 1\n  }\n}"
              },
              "prefix": "-cnv_type",
              "separate": true,
              "position": 50,
              "sbg:cmdInclude": true
            },
            "id": "#cnv_caller",
            "sbg:category": "Settings"
          }
        ],
        "outputs": [
          {
            "outputBinding": {
              "glob": "*.readdepth",
              "outputEval": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n\n  \n  base=$self[0].path\n  filename_full = base.split(\"/\")[base.split(\"/\").length - 1]\n  filename = filename_full.split(\".\")[(filename_full).split(\".\").length -2]\n  \n  \n  return parseInt(filename)\n\n\n\n}"
              }
            },
            "type": [
              "null",
              "int"
            ],
            "id": "#read_depth"
          },
          {
            "outputBinding": {
              "glob": "*.maxclust",
              "outputEval": {
                "engine": "#cwl-js-engine",
                "class": "Expression",
                "script": "{\n  \n  \n  \n  base=$self[0].path\n  filename_full = base.split(\"/\")[base.split(\"/\").length - 1]\n  filename = filename_full.split(\".\")[(filename_full).split(\".\").length -2]\n  \n  \n  return parseInt(filename)\n\n  \n\n}"
              }
            },
            "type": [
              "null",
              "int"
            ],
            "id": "#max_clust"
          }
        ],
        "hints": [
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          },
          {
            "dockerPull": "images.sbgenomics.com/sevenbridges/ubuntu:14.04",
            "dockerImageId": "",
            "class": "DockerRequirement"
          }
        ],
        "baseCommand": [
          "python3.4",
          "parameters.py"
        ],
        "stdin": "",
        "stdout": "",
        "successCodes": [],
        "temporaryFailCodes": [],
        "arguments": [],
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:image_url": null,
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1510330859,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-parameters/9"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1510846767,
            "sbg:revisionNotes": "Copy of uros_sipetic/sciclone-1-1-demo/sbg-sciclone-parameters/10"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1511279457,
            "sbg:revisionNotes": "Rewritten in Python.\nOptimized algorithm.\nCompatible with ubuntu:14.04 clean docker image."
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511310815,
            "sbg:revisionNotes": "Update CNVtype enum values."
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511312563,
            "sbg:revisionNotes": "Add default value for cnv_type"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511318200,
            "sbg:revisionNotes": "update cnv_type id to cnv_caller"
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1511347982,
            "sbg:revisionNotes": "Header bug fixed"
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1516107349,
            "sbg:revisionNotes": "Put '-cnv' prefix inside js expression to avoid unneeded prefix showing bug"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1522685306,
            "sbg:revisionNotes": "Improved algo for inferring the position of the CNV column"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1522685958,
            "sbg:revisionNotes": "Minor changes"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1526312370,
            "sbg:revisionNotes": null
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1526312661,
            "sbg:revisionNotes": "Added filtering sex chromosomes"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1526313454,
            "sbg:revisionNotes": "fix"
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1526314211,
            "sbg:revisionNotes": "fix 2"
          },
          {
            "sbg:revision": 14,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1526316025,
            "sbg:revisionNotes": "sex changed"
          },
          {
            "sbg:revision": 15,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528205717,
            "sbg:revisionNotes": "Merge regions to exclude into one list"
          },
          {
            "sbg:revision": 16,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528210931,
            "sbg:revisionNotes": "use_sex chromosomes set default to True"
          },
          {
            "sbg:revision": 17,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1528976994,
            "sbg:revisionNotes": "Fix unimportant bug"
          },
          {
            "sbg:revision": 18,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1530027780,
            "sbg:revisionNotes": "Expanded"
          },
          {
            "sbg:revision": 19,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1530097946,
            "sbg:revisionNotes": "Removed printing"
          },
          {
            "sbg:revision": 20,
            "sbg:modifiedBy": "danilo.jovanovic",
            "sbg:modifiedOn": 1533299629,
            "sbg:revisionNotes": "Fixed bug causing slow filtering for large vafs"
          },
          {
            "sbg:revision": 21,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1545866456,
            "sbg:revisionNotes": "Update docker image"
          },
          {
            "sbg:revision": 22,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1560771918,
            "sbg:revisionNotes": "Make CNV files optional"
          },
          {
            "sbg:revision": 23,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1560774629,
            "sbg:revisionNotes": "CNV inputs optional - fix js bug"
          },
          {
            "sbg:revision": 24,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1560776547,
            "sbg:revisionNotes": "fix cnv js expression"
          },
          {
            "sbg:revision": 25,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565624309,
            "sbg:revisionNotes": "Set default CN column to column4 (ignore CNV caller type)"
          },
          {
            "sbg:revision": 26,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565631037,
            "sbg:revisionNotes": "Flatten CNV input"
          },
          {
            "sbg:revision": 27,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565631627,
            "sbg:revisionNotes": "Fix expression in CNV flattening"
          }
        ],
        "cwlVersion": "sbg:draft-2",
        "sbg:cmdPreview": "python3.4 parameters.py -vaf /path/to/sample1.vaf,/path/to/sample2.vaf -regions /path/to/sample1.regions,/path/to/sample2.regions",
        "sbg:job": {
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          },
          "inputs": {
            "input_read_depth": 30,
            "input_cnv": [
              {
                "path": "/path/to/sample1.cnv",
                "class": "File",
                "size": 0,
                "secondaryFiles": [],
                "metadata": {
                  "sample_id": "1"
                }
              },
              {
                "path": "/path/to/sample2.cnv",
                "class": "File",
                "size": 0,
                "secondaryFiles": [],
                "metadata": {
                  "sample_id": "2"
                }
              }
            ],
            "input_cnv_tresh": null,
            "read_resolution": null,
            "input_regions": [
              {
                "size": 0,
                "path": "/path/to/sample1.regions",
                "class": "File",
                "secondaryFiles": []
              },
              {
                "size": 0,
                "path": "/path/to/sample2.regions",
                "class": "File",
                "secondaryFiles": []
              }
            ],
            "use_sex": null,
            "input_max_clust": null,
            "cnv_caller": "CNVkit",
            "input_vaf": [
              {
                "size": 0,
                "path": "/path/to/sample1.vaf",
                "class": "File",
                "metadata": {
                  "sample_id": "1"
                },
                "secondaryFiles": []
              },
              {
                "path": "/path/to/sample2.vaf",
                "class": "File",
                "size": 0,
                "secondaryFiles": [],
                "metadata": {
                  "sample_id": "2"
                }
              }
            ]
          }
        },
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "sbg:toolAuthor": "Danilo Jovanovic",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "bix-demo/sbgtools-demo/sbg-sciclone-parameters/27",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-sciclone-parameters/27",
        "sbg:revision": 27,
        "sbg:revisionNotes": "Fix expression in CNV flattening",
        "sbg:modifiedOn": 1565631627,
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:createdOn": 1510330859,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic",
          "danilo.jovanovic"
        ],
        "sbg:latestRevision": 27,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a09a303d4bdae00dc7d2fd0e55f3f6a3fbad5cf52fa7e4e83c03e8ba5bcb89127",
        "x": 924.4635881696433,
        "y": 433.5905892508372
      },
      "inputs": [
        {
          "id": "#SBG_SciClone_Parameters.use_sex",
          "source": [
            "#useSexChrs"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.read_resolution",
          "source": [
            "#read_resolution"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_vaf",
          "source": [
            "#SBG_SciClone_VCF_parser.vafs"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_regions",
          "source": [
            "#SBG_SciClone_VCF_parser.regions_to_exclude",
            "#SBG_Get_LOH_Regions.output_file"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_read_depth",
          "default": 80,
          "source": [
            "#input_read_depth"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_max_clust",
          "source": [
            "#input_max_clust"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_cnv_tresh",
          "source": [
            "#copyNumberMargins"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.input_cnv",
          "source": [
            "#SBG_CNV_Converter.converted_files"
          ]
        },
        {
          "id": "#SBG_SciClone_Parameters.cnv_caller"
        }
      ],
      "outputs": [
        {
          "id": "#SBG_SciClone_Parameters.read_depth"
        },
        {
          "id": "#SBG_SciClone_Parameters.max_clust"
        }
      ],
      "sbg:x": 924.4635881696433,
      "sbg:y": 433.5905892508372
    },
    {
      "id": "#SBG_CNV_Converter",
      "run": {
        "class": "CommandLineTool",
        "label": "SBG CNV Converter",
        "description": "This app accepts CNV results from a plethora of popular CNV callers, and parses to a standard, unified CNV format.",
        "requirements": [
          {
            "class": "CreateFileRequirement",
            "fileDef": [
              {
                "filename": "sbg_cveto_util.py",
                "fileContent": "import logging\nimport numpy as np\nimport pandas as pd\nfrom itertools import chain, combinations\nimport matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt\nimport matplotlib.ticker as ticker\n\nCNV_COLUMNS = ['caller', 'chromosome', 'start', 'end', 'status', 'cn', 'cn1',\n               'cn2']\nCNV_DTYPES = {'caller': str, 'chromosome': str, 'start': np.float64,\n              'end': np.float64, 'status': str, 'cn': np.float64,\n              'cn1': np.float64, 'cn2': np.float64}\n\n\ndef init_logging(appname, level=logging.INFO, output_filename=None):\n    \"\"\"\n    Initialize console logger.\n\n    :param appname: Name of the app for which logging is initialized\n    :param level: Log-level, default INFO\n    :param output_filename: If provided, logging is sent to console AND to file\n    :return: Initialized Logger object\n    \"\"\"\n\n    # create logger\n    if output_filename is not None:\n        logging.basicConfig(filename=output_filename, level=level)\n    logger = logging.getLogger(appname)\n    logger.setLevel(level)\n\n    # # create file handler which logs even debug messages\n    # fh = logging.FileHandler('appname.log')\n    # fh.setLevel(logging.DEBUG)\n\n    # create console handler with INFO log level\n    ch = logging.StreamHandler()\n    ch.setLevel(level)\n\n    # create formatter and add it to the handler(s)\n    formatter = logging.Formatter(\n        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')\n    # fh.setFormatter(formatter)\n    ch.setFormatter(formatter)\n\n    # add handler(s) to the logger\n    # logger.addHandler(fh)\n    logger.addHandler(ch)\n\n    return logger\n\n\nclass Region:\n    \"\"\"\n    Container for region data. Can be derived from a single truth or query row,\n    or describe overlap of any number of truth and query rows.\n\n    sources: keeps a list of source rows for each caller represented in this\n             region\n    \"\"\"\n\n    def __init__(self, chromosome, start, end, sourcess,\n                 allow_duplicates=False):\n        \"\"\"\n        Initialize a new Region object.\n\n        :param chromosome: Chromosome for region\n        :param start: Start of region, inclusive\n        :param end: End of region, exclusive\n        :param sourcess: List of dicts of references to source rows\n        :param allow_duplicates: Duplicate callers allowed in the region\n        \"\"\"\n        self.chromosome = chromosome\n        self.start = start\n        self.end = end\n        # This merges input list of dicts sourcess into self.sources dict\n        self.sources = {}\n        # Run through list of dicts\n        for sources in sourcess:\n            for caller in sources:\n                if not allow_duplicates and caller in self.sources:\n                    msg = 'Cannot add duplicate {} to region {}({:010d}, {:010d}).'.format(\n                        caller, chromosome, int(start), int(end))\n                    raise UserWarning(msg)\n\n                self.sources[caller] = sources[caller]\n\n    def __repr__(self):\n        \"\"\"\n        Region is represented by the following format (start and end are left-\n        padded with 0's to maintain 10 digit integers):\n        chromosome(start, end)[callers present in region].\n\n        Notes:\n        - Caller listing is alphabetically sorted.\n        - CAUTION: This function is used as a key for sorting regions, be\n          careful when modifying!\n\n        Example:\n        chrX(0000012345, 0000067890)['BED', 'CNVkit', 'PureCN', 'truth']\n\n        :return: String representation of this Region\n        \"\"\"\n        return '{}({:010d}, {:010d}){}'.format(self.chromosome,\n                                               int(self.start),\n                                               int(self.end),\n                                               sorted(self.sources.keys()))\n\n    def intersect(self, region, allow_duplicates=False):\n        \"\"\"\n        Intersect two regions to determine head, overlap and tail regions.\n\n        CAUTION: Assumes 'self' comes before 'region',\n                 sorting should be performed outside!\n\n        :param region: Region to intersect with self region\n        :param allow_duplicates: Duplicate callers allowed in the region\n        :return: Outs list containing head and overlap regions (may be an empty\n                 list), tail region (may be None)\n        \"\"\"\n        outs = []\n        tail = None\n\n        # If different chromosomes, then self region is head, no overlap and\n        # other region is tail (assumes 'self' comes before 'region', sorting\n        # should be performed outside!)\n        if self.chromosome != region.chromosome:\n            outs.append(self)\n            tail = region\n            return outs, tail\n\n        # Head\n        if self.start < region.start:\n            outs.append(\n                Region(self.chromosome, self.start, min(self.end, region.start),\n                       [self.sources]))\n        elif self.start > region.start:\n            outs.append(Region(region.chromosome, region.start,\n                               min(region.end, self.start), [region.sources]))\n\n        # Overlap\n        if self.end > region.start and self.start < region.end:\n            outs.append(Region(self.chromosome, max(self.start, region.start),\n                               min(self.end, region.end),\n                               [self.sources, region.sources],\n                               allow_duplicates))\n\n        # Tail\n        if self.end < region.end:\n            tail = Region(region.chromosome, max(self.end, region.start),\n                          region.end, [region.sources])\n        elif self.end > region.end:\n            tail = Region(self.chromosome, max(self.start, region.end),\n                          self.end, [self.sources])\n\n        return outs, tail\n\n    def to_series(self, callers):\n        \"\"\"\n        Get a Pandas Series representation of this region to be used to form\n        the analysis DataFrame.\n\n        :param callers: List of callers to take into account\n        :return: Pandas Series representation of this region\n        \"\"\"\n        data = {'chromosome': self.chromosome,\n                'start': self.start,\n                'end': self.end,\n                'length': self.end - self.start}\n\n        for caller in sorted(callers):\n            # Set caller status column\n            status = np.NaN\n            if caller in self.sources:\n                status = self.sources[caller]['status']\n            data['{}_status'.format(caller)] = status\n\n        return pd.Series(data)\n\n    def to_series_for_consensus(self):\n        \"\"\"\n        Get a Pandas Series representation of this region to be used to form\n        the consensus DataFrame.\n\n        Notes:\n        - 'freec': caller name for Control-FREEC input file\n        - 'gatk_called': caller name for GATK4 CNV called.seg input file\n        - 'gatk_model': caller name for GATK4 CNV modelFinal.seg input file\n\n        :return: Pandas Series representation of this region\n        \"\"\"\n        data = {'chromosome': self.chromosome, 'start': int(self.start),\n                'end': int(self.end)}\n\n        # Init Control-FREEC columns\n        freec_status = np.NaN\n        freec_genotype = np.NaN\n        freec_cn = np.NaN\n        freec_cn1 = np.NaN\n        freec_cn2 = np.NaN\n        freec_prediction = 'neutral'\n\n        if 'freec' in self.sources:\n            freec_status = self.sources['freec']['status']\n            freec_genotype = self.sources['freec']['genotype']\n            freec_cn = self.sources['freec']['cn']\n            freec_cn1 = self.sources['freec']['cn1']\n            freec_cn2 = self.sources['freec']['cn2']\n            freec_prediction = freec_status\n\n        # Init GATK called columns\n        gatk_status = np.NaN\n        gatk_cn = np.NaN\n        gatk_call = np.NaN\n        gatk_ml2cr = np.NaN\n        gatk_prediction = 'neutral'\n\n        if 'gatk_called' in self.sources:\n            gatk_status = self.sources['gatk_called']['status']\n            gatk_cn = self.sources['gatk_called']['cn']\n            gatk_call = self.sources['gatk_called']['CALL']\n            gatk_ml2cr = self.sources['gatk_called']['MEAN_LOG2_COPY_RATIO']\n            gatk_prediction = gatk_status\n\n        # Init GATK model columns\n        gatk_mafp50 = np.NaN\n\n        if 'gatk_model' in self.sources:\n            gatk_mafp50 = self.sources['gatk_model'][\n                'MINOR_ALLELE_FRACTION_POSTERIOR_50']\n\n        # Make a (consensus) prediction\n        if freec_prediction == gatk_prediction:\n            status = freec_prediction\n            confidence = 'high'\n            support = 'freec,gatk'\n        elif freec_prediction == 'neutral':\n            status = gatk_prediction\n            confidence = 'low'\n            support = 'gatk'\n        elif gatk_prediction == 'neutral':\n            status = freec_prediction\n            confidence = 'low'\n            support = 'freec'\n        else:\n            status = 'complex'\n            confidence = 'no'\n            support = np.NaN\n\n        # Prepare output dict\n        data['status'] = status\n        data['confidence'] = confidence\n        data['support'] = support\n\n        data['freec_status'] = freec_status\n        data['freec_genotype'] = freec_genotype\n        data['freec_cn'] = freec_cn if np.isnan(freec_cn) else str(\n            int(freec_cn))\n        data['freec_cn1'] = freec_cn1 if np.isnan(freec_cn1) else str(\n            int(freec_cn1))\n        data['freec_cn2'] = freec_cn2 if np.isnan(freec_cn2) else str(\n            int(freec_cn2))\n\n        data['gatk_status'] = gatk_status\n        data['gatk_cn'] = gatk_cn\n        data['gatk_call'] = gatk_call\n        data['gatk_mean_log2_copy_ratio'] = gatk_ml2cr\n        data['gatk_minor_allele_fraction_posterior_50'] = gatk_mafp50\n\n        return pd.Series(data)\n\n    def to_series_for_gatk(self):\n        \"\"\"\n        Get a Pandas Series representation of this region to be used to form\n        the GATK DataFrame (combination of called.seg and modelFinal.seg files).\n\n        Notes:\n        - 'gatk_called': caller name for GATK4 CNV called.seg input file\n        - 'gatk_model': caller name for GATK4 CNV modelFinal.seg input file\n\n        :return: Pandas Series representation of this region\n        \"\"\"\n        data = {'chromosome': self.chromosome,\n                'start': self.start,\n                'end': self.end,\n                'length': self.end - self.start}\n\n        # Init GATK called columns\n        status = np.NaN\n        cn = np.NaN\n        ml2cr = np.NaN\n        call = np.NaN\n\n        if 'gatk_called' in self.sources:\n            status = self.sources['gatk_called']['status']\n            cn = self.sources['gatk_called']['cn']\n            ml2cr = self.sources['gatk_called']['MEAN_LOG2_COPY_RATIO']\n            call = self.sources['gatk_called']['CALL']\n\n        # Init GATK model columns\n        mafp50 = np.NaN\n        l2crp50 = np.NaN\n\n        if 'gatk_model' in self.sources:\n            mafp50 = self.sources['gatk_model'][\n                'MINOR_ALLELE_FRACTION_POSTERIOR_50']\n            l2crp50 = self.sources['gatk_model']['LOG2_COPY_RATIO_POSTERIOR_50']\n\n        # Infer cn1 and cn2 (LOH)\n        cn1 = np.NaN\n        cn2 = np.NaN\n\n        if not np.isnan(cn) and not np.isnan(mafp50):\n            cn1 = cn * mafp50\n            cn2 = cn - cn1\n\n        data['status'] = status\n        data['cn'] = cn if np.isnan(cn) else round(cn, 1)\n        data['cn1'] = cn1 if np.isnan(cn1) else round(cn1, 1)\n        data['cn2'] = cn2 if np.isnan(cn2) else round(cn, 1) - round(cn1, 1)\n        data['call'] = call\n        data['mean_log2_copy_ratio'] = ml2cr\n        data['log2_copy_ratio_posterior_50'] = l2crp50\n        data['minor_allele_fraction_posterior50'] = mafp50\n\n        return pd.Series(data)\n\n    def to_series_for_sv(self):\n        \"\"\"\n        Get a Pandas Series representation of this region to be used to form\n        the SV initiated DataFrame.\n\n        CAUTION: region.sources contains SVs 'DEL' and 'DUP', not caller names!\n\n        :return: Pandas Series representation of this region\n        \"\"\"\n        data = {'chromosome': self.chromosome,\n                'start': self.start,\n                'end': self.end}\n\n        if len(self.sources.keys()) == 1:\n            if 'DEL' in self.sources:\n                # Assume minimal loss\n                data['status'] = 'loss'\n                data['cn'] = 1\n                data['cn1'] = 0\n                data['cn2'] = 1\n            if 'DUP' in self.sources:\n                # Assume minimal gain\n                data['status'] = 'gain'\n                data['cn'] = 3\n                data['cn1'] = 1\n                data['cn2'] = 2\n        elif len(self.sources.keys()) == 2:\n            # Assume loss of heterozygosity, since DEL and DUP overlap\n            data['status'] = 'neutral'\n            data['cn'] = 2\n            data['cn1'] = 0\n            data['cn2'] = 2\n\n        return pd.Series(data)\n\n\ndef read_cnvkit_no_loh_csv(path, caller):\n    \"\"\"\n    Read No-LOH CNVkit CSV file into a Pandas DataFrame.\n\n    :param path: Path to No-LOH CNVkit CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of No-LOH CNVkit CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_cnvkit_csv(path, caller):\n    \"\"\"\n    Read CNVkit CSV file into a Pandas DataFrame.\n\n    :param path: Path to CNVkit CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of CNVkit CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_purecn_no_loh_csv(path, caller):\n    \"\"\"\n    Read No-LOH PureCN CSV file into a Pandas DataFrame.\n\n    :param path: Path to No-LOH PureCN CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of No-LOH PureCN CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    purecn_no_loh_mapper = {'chrom': 'chromosome', 'loc.start': 'start',\n                            'loc.end': 'end', 'C': 'cn'}\n    df.rename(mapper=purecn_no_loh_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_purecn_csv(path, caller):\n    \"\"\"\n    Read PureCN CSV file into a Pandas DataFrame.\n\n    :param path: Path to PureCN CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of PureCN CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = ','\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    purecn_mapper = {'chr': 'chromosome', 'C': 'cn', 'M': 'cn1'}\n    df.rename(mapper=purecn_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    # Calculate cn2\n    df['cn2'] = df.cn - df.cn1\n\n    return df\n\n\ndef read_controlfreec_csv(path, caller, for_benchmark=True):\n    \"\"\"\n    Read ControlFREEC CSV file into a Pandas DataFrame.\n\n    :param path: Path to ControlFREEC CSV file\n    :param caller: Name of the caller\n    :param for_benchmark: Removes excess columns when set to True\n    :return: Pandas DataFrame representation of ControlFREEC CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    control_freec_mapper = {'chr': 'chromosome', 'copy number': 'cn'}\n    df.rename(mapper=control_freec_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Fill genotype with unknown if missing\n    if 'genotype' not in df.columns:\n        df['genotype'] = '-'\n\n    # Infer cn1 and cn2 from genotype field\n    df[['cn1', 'cn2']] = df['genotype'].apply(extract_cn1_and_cn2)\n\n    # Set DTypes\n    if for_benchmark:\n        df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_controlfreec_no_loh_csv(path, caller):\n    \"\"\"\n    Read ControlFREEC no-LOH CSV file into a Pandas DataFrame.\n\n    :param path: Path to ControlFREEC no-LOH CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of ControlFREEC no-LOH CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    control_freec_mapper = {'chr': 'chromosome', 'copy number': 'cn'}\n    df.rename(mapper=control_freec_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Fill genotype with unknown if missing\n    if 'genotype' not in df.columns:\n        df['genotype'] = '-'\n\n    # Infer cn1 and cn2 from genotype field\n    df[['cn1', 'cn2']] = df['genotype'].apply(extract_cn1_and_cn2)\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_controlfreec_no_header_csv(path, caller, for_benchmark=True):\n    \"\"\"\n    Read ControlFREEC no-header CSV file into a Pandas DataFrame.\n\n    :param path: Path to ControlFREEC no-header CSV file\n    :param caller: Name of the caller\n    :param for_benchmark: Removes excess columns when set to True\n    :return: Pandas DataFrame representation of ControlFREEC no-header CSV file\n    \"\"\"\n    skiprows = 0\n    header = None\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n\n    df.columns = ['chromosome', 'start', 'end', 'cn',\n                  'status', 'genotype', 'uncertainty']\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Fill genotype with unknown if missing\n    if 'genotype' not in df.columns:\n        df['genotype'] = '-'\n\n    # Infer cn1 and cn2 from genotype field\n    df[['cn1', 'cn2']] = df['genotype'].apply(extract_cn1_and_cn2)\n\n    # Set DTypes\n    if for_benchmark:\n        df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_controlfreec_no_loh_no_header_csv(path, caller):\n    \"\"\"\n    Read ControlFREEC no-LOH no-header CSV file into a Pandas DataFrame.\n\n    :param path: Path to ControlFREEC CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of ControlFREEC\n             no-LOH no-header CSV file\n    \"\"\"\n    skiprows = 0\n    header = None\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n\n    df.columns = ['chromosome', 'start', 'end', 'cn', 'status']\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Fill genotype with unknown if missing\n    if 'genotype' not in df.columns:\n        df['genotype'] = '-'\n\n    # Infer cn1 and cn2 from genotype field\n    df[['cn1', 'cn2']] = df['genotype'].apply(extract_cn1_and_cn2)\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_cnvnator_csv(path, caller):\n    \"\"\"\n    Read CNVnator CSV file into a Pandas DataFrame.\n\n    :param path: Path to CNVnator CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of CNVnator CSV file\n    \"\"\"\n    skiprows = 0\n    header = None\n    sep = '\\t'\n    comment = 'N'\n\n    cnvnator_columns = ['call', 'coordinates', 'CNV_size', 'normalized_RD',\n                        'e-val1', 'e-val2', 'e-val3', 'e-val4', 'q0']\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, names=cnvnator_columns, comment=comment)\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Convert CNVnator columns to CNV columns\n    df['chromosome'] = df['coordinates'].apply(lambda x: x.split(':')[0])\n    df['start'] = df['coordinates'].apply(\n        lambda x: x.split(':')[1].split('-')[0])\n    df['end'] = df['coordinates'].apply(lambda x: x.split(':')[1].split('-')[1])\n    df['status'] = df['call'].map({'deletion': 'loss', 'duplication': 'gain'})\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_icr96_truth_csv(path, caller):\n    \"\"\"\n    Read ICR96 truth CSV file into a Pandas DataFrame.\n\n    :param path: Path to ICR96 truth CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of ICR96 truth CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    icr96_mapper = {'ExonCNVType': 'cn'}\n    df.rename(mapper=icr96_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_sequenza_csv(path, caller):\n    \"\"\"\n    Read Sequenza CSV file into a Pandas DataFrame.\n\n    :param path: Path to Sequenza CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of Sequenza CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    sequenza_mapper = {'start.pos': 'start', 'end.pos': 'end', 'CNt': 'cn',\n                       'A': 'cn1', 'B': 'cn2'}\n    df.rename(mapper=sequenza_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_gatk_called_csv(path, caller, for_benchmark=True):\n    \"\"\"\n    Read GATK4 CNV CSV file into a Pandas DataFrame.\n\n    :param path: Path to GATK4 CNV CSV file\n    :param caller: Name of the caller\n    :param for_benchmark: Removes excess columns when set to True\n    :return: Pandas DataFrame representation of GATK4 CNV CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '@'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    gatk_called_mapper = {'CONTIG': 'chromosome', 'START': 'start',\n                          'END': 'end'}\n    df.rename(mapper=gatk_called_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on CALL column: '-': 'loss', '0': 'neutral', '+': 'gain'\n    df['status'] = df['CALL'].map({'-': 'loss', '0': 'neutral', '+': 'gain'})\n\n    # Set cn based on MEAN_LOG2_COPY_RATIO column, assume 2 is baseline\n    df['cn'] = (2 ** (df['MEAN_LOG2_COPY_RATIO'] + 1)).round(1)\n\n    # Set DTypes\n    if for_benchmark:\n        df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_gatk_model_csv(path, caller, for_benchmark=True):\n    \"\"\"\n    Read GATK Model Final SEG CSV file into a Pandas DataFrame.\n\n    :param path: Path to GATK Model Final SEG CSV file\n    :param caller: Name of the caller\n    :param for_benchmark: Removes excess columns when set to True\n    :return: Pandas DataFrame representation of GATK Model Final SEG CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '@'\n    na_values = 'NaN'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment, na_values=na_values)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    gatk_model_mapper = {'CONTIG': 'chromosome', 'START': 'start', 'END': 'end'}\n    df.rename(mapper=gatk_model_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set DTypes\n    if for_benchmark:\n        df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_facets_csv(path, caller):\n    \"\"\"\n    Read Facets CSV file into a Pandas DataFrame.\n\n    :param path: Path to Facets CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of Facets CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    facets_cnv_mapper = {'chrom': 'chromosome', 'tcn.em': 'cn', 'lcn.em': 'cn1'}\n    df.rename(mapper=facets_cnv_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    # Set cn2 based on cn1 column\n    df['cn2'] = df['cn'] - df['cn1']\n\n    return df\n\n\ndef read_scnvsim_csv(path, caller):\n    \"\"\"\n    Read SCNVSim simulated CSV file into a Pandas DataFrame.\n\n    :param path: Path to SCNVSim simulated CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of SCNVSim simulated CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    scnvsim_mapper = {'chr': 'chromosome', 'Start': 'start', 'End': 'end',\n                      'Copy_Number': 'cn'}\n    df.rename(mapper=scnvsim_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    # SCNVSim reports difference from baseline (2)\n    df['cn'] = df['cn'] + 2\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    return df\n\n\ndef read_simulatecnvs_csv(path, caller):\n    \"\"\"\n    Read SimulateCNVs simulated CSV file into a Pandas DataFrame.\n\n    :param path: Path to SimulateCNVs simulated CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of SimulateCNVs simulated CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    simulatecnvs_mapper = {'chr': 'chromosome', 'copy_number': 'cn'}\n    df.rename(mapper=simulatecnvs_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_varsimlab_csv(path, caller):\n    \"\"\"\n    Read VarSimLab simulated CSV file into a Pandas DataFrame.\n\n    :param path: Path to VarSimLab simulated CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of VarSimLab simulated CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment)\n    df['caller'] = caller\n\n    # Rename columns to match CNV_COLUMNS names\n    varsimlab_mapper = {'chr': 'chromosome', 'location': 'start',\n                        'copies1': 'cn1', 'copies2': 'cn2'}\n    df.rename(mapper=varsimlab_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Strip chromosome column\n    df['chromosome'] = df['chromosome'].str.strip()\n\n    # Set end based on start and seq_size columns\n    df['end'] = df['start'] + df['seq_size']\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    # Set cn based on cn1 and cn2 columns\n    df['cn'] = df['cn1'] + df['cn2']\n\n    # Set status based on cn\n    cond = df['cn'] < 2\n    df.loc[cond, 'status'] = 'loss'\n    cond = df['cn'] == 2\n    df.loc[cond, 'status'] = 'neutral'\n    cond = df['cn'] > 2\n    df.loc[cond, 'status'] = 'gain'\n\n    return df\n\n\ndef read_bed_csv(path, caller):\n    \"\"\"\n    Read BED CSV file into a Pandas DataFrame.\n\n    :param path: Path to BED CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of BED CSV file\n    \"\"\"\n    skiprows = 0\n    header = None\n    sep = '\\t'\n    comment = '#'\n\n    bed_columns = ['chromosome', 'start', 'end']\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, names=bed_columns, comment=comment)\n    df['caller'] = caller\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_sbg_conseca_cnv(path, caller, for_benchmark=True):\n    \"\"\"\n    Read SBG Conseca CNV CSV file into a Pandas DataFrame.\n\n    :param path: Path to SBG Conseca CNV CSV file\n    :param caller: Name of the caller\n    :param for_benchmark: Removes excess columns when set to True\n    :return: Pandas DataFrame representation of SBG Conseca CNV CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n    na_values = '.'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     comment=comment, na_values=na_values, sep=sep)\n    df['caller'] = caller\n\n    if for_benchmark:\n        # Rename columns to match CNV_COLUMNS names\n        conseca_mapper = {'freec_cn': 'cn', 'freec_cn1': 'cn1',\n                          'freec_cn2': 'cn2'}\n        df.rename(mapper=conseca_mapper, axis='columns', inplace=True)\n\n    # Add missing columns and set them to np.NaN\n    for column in CNV_COLUMNS:\n        if column not in df.columns:\n            df[column] = np.NaN\n\n    if for_benchmark:\n        # Filter out low and no confidence calls\n        cond = df['confidence'] == 'high'\n        df = df[cond]\n\n    # Set DTypes\n    if for_benchmark:\n        df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\ndef read_sveto_prep_cnv_csv(path, caller):\n    \"\"\"\n    Read SVeto Prepare CNV CSV file into a Pandas DataFrame.\n\n    :param path: Path to SVeto Prepare CNV CSV file\n    :param caller: Name of the caller\n    :return: Pandas DataFrame representation of SVeto Prepare CNV CSV file\n    \"\"\"\n    skiprows = 0\n    header = 0\n    sep = '\\t'\n    comment = '#'\n\n    df = pd.read_csv(filepath_or_buffer=path, skiprows=skiprows, header=header,\n                     sep=sep, comment=comment, na_values='.')\n    df['caller'] = caller\n\n    # Set DTypes\n    df = df[CNV_COLUMNS].copy()\n    for key in CNV_DTYPES:\n        df[key] = df[key].astype(CNV_DTYPES[key])\n\n    return df\n\n\n# TODO sync caller names, formats and file extensions\ndef read_csv(path, caller, cnv_format=None):\n    \"\"\"\n    Read CNV CSV with the appropriate reader, based on the file extension.\n\n    *.no_loh.cns:       read_cnvkit_no_loh_csv()\n    *.cns:              read_cnvkit_csv()\n    *.called.seg:       read_gatk_called_csv()\n    *.modelFinal.seg:   read_gatk_model_csv()\n    *.seg:              read_purecn_no_loh_csv()\n    *_loh.csv:          read_purecn_csv()\n    *.value.txt:        read_controlfreec_csv()\n    *.CNV_results.txt:  read_varsimlab_csv()\n    *_results.txt:      read_cnvnator_csv()\n    *.exon.csv:         read_icr96_truth_csv()\n    *segments.txt:      read_sequenza_csv()\n    *.cncf.tsv:         read_facets_csv()\n    *.scnvsim.bed:      read_scnvsim_csv()\n    *_exon.bed:         read_simulatecnvs_csv()\n    *.bed:              read_bed_csv()\n    *.sveto-prep.cnv:   read_sveto_prep_cnv_csv()\n    *.conseca.tsv:      read_sbg_conseca_cnv()\n\n    :param path: Path to CNV CSV file\n    :param caller: Name of the caller\n    :param cnv_format: Format of the CNV file\n    :return: Pandas DataFrame representation of CNV CSV file\n    \"\"\"\n\n    cnv_readers = {'bed': read_bed_csv,\n                   'cnvkit': read_cnvkit_csv,\n                   'cnvkit_no_loh': read_cnvkit_no_loh_csv,\n                   'cnvnator': read_cnvnator_csv,\n                   'controlfreec': read_controlfreec_csv,\n                   'controlfreec_no_loh': read_controlfreec_no_loh_csv,\n                   'controlfreec_no_header': read_controlfreec_no_header_csv,\n                   'controlfreec_no_loh_no_header':\n                       read_controlfreec_no_loh_no_header_csv,\n                   'facets': read_facets_csv,\n                   'gatk_called': read_gatk_called_csv,\n                   'gatk_model': read_gatk_model_csv,\n                   'icr96': read_icr96_truth_csv,\n                   'purecn': read_purecn_csv,\n                   'purecn_no_loh': read_purecn_no_loh_csv,\n                   'scnvsim': read_scnvsim_csv,\n                   'sequenza': read_sequenza_csv,\n                   'simulatecnvs': read_simulatecnvs_csv,\n                   'varsimlab': read_varsimlab_csv,\n                   'sveto_prep_cnv': read_sveto_prep_cnv_csv,\n                   'sbg_conseca_cnv': read_sbg_conseca_cnv\n                   }\n\n    if cnv_format in cnv_readers:\n        df = cnv_readers[cnv_format](path, caller)\n        df = df.sort_values(['chromosome', 'start'])\n        return df\n\n    # CNVkit no LOH\n    if path.endswith('.no_loh.cns') or path.endswith('_cnv.txt'):\n        df = read_cnvkit_no_loh_csv(path, caller)\n    # CNVkit\n    elif path.endswith('.cns'):\n        df = read_cnvkit_csv(path, caller)\n    # GATK called\n    elif path.endswith('.called.seg'):\n        df = read_gatk_called_csv(path, caller)\n    # GATK model\n    elif path.endswith('.modelFinal.seg'):\n        df = read_gatk_model_csv(path, caller)\n    # PureCN no LOH\n    elif path.endswith('.seg'):\n        df = read_purecn_no_loh_csv(path, caller)\n    # PureCN\n    elif path.endswith('_loh.csv'):\n        df = read_purecn_csv(path, caller)\n    # ControlFREEC\n    elif path.endswith('.value.txt'):\n        df = read_controlfreec_csv(path, caller)\n    # VarSimLab\n    elif path.endswith('.CNV_results.txt'):\n        df = read_varsimlab_csv(path, caller)\n    # CNVnator\n    elif path.endswith('.calling_results.txt'):\n        df = read_cnvnator_csv(path, caller)\n    # ICR96 truth\n    elif path.endswith('.exon.csv'):\n        df = read_icr96_truth_csv(path, caller)\n    # Sequenza\n    elif path.endswith('.segments.txt'):\n        df = read_sequenza_csv(path, caller)\n    # Facets\n    elif path.endswith('.cncf.tsv'):\n        df = read_facets_csv(path, caller)\n    # SCNVSim\n    elif path.endswith('.scnvsim.bed'):\n        df = read_scnvsim_csv(path, caller)\n    # SimulateCNVs\n    elif path.endswith('.overlap_exon.bed'):\n        df = read_simulatecnvs_csv(path, caller)\n    # BED\n    elif path.endswith('.bed'):\n        df = read_bed_csv(path, caller)\n    # SVeto Prepare SV -> CNV\n    elif path.endswith('.sveto-prep.cnv'):\n        df = read_sveto_prep_cnv_csv(path, caller)\n    # SBG Conseca CNV\n    elif path.endswith('.conseca.tsv'):\n        df = read_sbg_conseca_cnv(path, caller)\n    else:\n        extension = 'unknown'\n        if path:\n            extension = path.split('.')[-1]\n        raise UserWarning('File type \"{}\" is not supported.'.format(extension))\n\n    df = df.sort_values(['chromosome', 'start'])\n    return df\n\n\ndef convert_cnv_to_ss(df):\n    \"\"\"\n    Output CN calls from CN Dataframe to ShatterSeek SSCN calls.\n\n    :param df: CN DataFrame\n    :return: Dataframe in format of ShatterSeek CN (SSCN)\n    \"\"\"\n    ss_mapper = {'chromosome': 'chrom', 'cn': 'total_cn'}\n    df_ss = df[['chromosome', 'start', 'end', 'cn']].copy()\n    df_ss.rename(mapper=ss_mapper, axis='columns', inplace=True)\n\n    # Remove CHR, Chr, chr from chromosome name\n    # This also ensures that X is X and not x\n    df_ss.chrom = df_ss.chrom.str.upper().str.replace('CHR', '')\n\n    # Keep 1, 2, ... 22, X chromosomes\n    valid_chroms = '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X'\n    valid_chroms = valid_chroms.split()\n    cond = df_ss.chrom.isin(valid_chroms)\n    df_ss = df_ss[cond]\n\n    # Set dtypes for pos1 and pos2\n    df_ss.start = df_ss.start.astype(int)\n    df_ss.end = df_ss.end.astype(int)\n\n    return df_ss\n\n\ndef write_cnv(df, columns, output):\n    \"\"\"\n    Write CN DataFrame to provided output stream.\n\n    :param df: DataFrame to output\n    :param columns: List of columns to output (also sets column order)\n    :param output: Stream (opened file) to write to\n    :return:\n    \"\"\"\n    cnv = df[columns].to_csv(sep='\\t', index=False, na_rep='.')\n    output.write(cnv)\n\n\ndef fix_chromosomes(df):\n    \"\"\"\n    Remove CHR/Chr/chr from contig ID and filter out alternative contigs - leave\n    only 1, 2, ..., 22, X and Y contigs.\n\n    :param df: DataFrame to be processed, must contain 'chromosome' column\n    :return: Processed and filtered DataFrame\n    \"\"\"\n    # Remove CHR, Chr, chr from chromosome name\n    # This also ensures that X is X and not x\n    df['chromosome'] = df['chromosome'].str.upper().str.replace('CHR', '')\n\n    # Keep 1, 2, ... 22, X, Y chromosomes\n    chromosomes = '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y'\n    chromosomes = chromosomes.split()\n    cond = df['chromosome'].isin(chromosomes)\n\n    return df[cond]\n\n\ndef extract_cn1_and_cn2(genotype):\n    \"\"\"\n    Infer cn1 and cn2 values from Control-FREEC 'genotype' column\n    :param genotype: Control-FREEC 'genotype' column (e.g. 'AAABB')\n    :return: Series object with inferred 'cn1' and 'cn2' columns\n    \"\"\"\n    cnt_a = genotype.count('A')\n    cnt_b = genotype.count('B')\n\n    if cnt_a == 0 and cnt_b == 0:\n        return pd.Series({'cn1': np.NaN, 'cn2': np.NaN})\n    else:\n        return pd.Series({'cn1': cnt_a, 'cn2': cnt_b})\n\n\ndef remove_overlaps_from_df(df, method='SWAP'):\n    \"\"\"\n    Look for overlaps in a DataFrame (region[i+1].start < region[i].end) and\n    fix it by swapping those 2 values.\n\n    :param df: DataFrame to remove overlaps from\n    :param method: SWAP [n+1].start and [n].end; SPLIT set both to rounded mean\n    :return: DataFrame with no overlaps\n    \"\"\"\n    cur = None\n    for index, row in df.sort_values(['chromosome', 'start', 'end']).iterrows():\n        if cur is None:\n            cur = {'index': index, 'chromosome': row.chromosome,\n                   'start': row.start, 'end': row.end}\n            continue\n\n        if cur['chromosome'] == row.chromosome and cur['end'] > row.start:\n            if cur['end'] >= row.end:\n                raise UserWarning(\n                    'Error removing overlap for {} and {}'.format(cur, row))\n\n            left = row.start\n            right = cur['end']\n            if method == 'SWAP':\n                print('Warning: Removing self-intersection at {}({}:{})'.format(\n                    row.chromosome, int(left), int(right)))\n\n            if method == 'SWAP':\n                df.loc[cur['index'], 'end'] = left\n                df.loc[index, 'start'] = right\n            elif method == 'SPLIT':\n                middle = int((left + right) / 2)\n                df.loc[cur['index'], 'end'] = middle\n                df.loc[index, 'start'] = middle\n\n            cur = {'index': index, 'chromosome': row.chromosome,\n                   'start': right, 'end': row.end}\n        else:\n            cur = {'index': index, 'chromosome': row.chromosome,\n                   'start': row.start, 'end': row.end}\n\n\ndef to_regions(dataframe):\n    \"\"\"\n    Create a list of Regions based on a DataFrame.\n\n    :param dataframe: DataFrame to create Regions list from\n    :return: List of Regions corresponding to the input DataFrame\n    \"\"\"\n    return [Region(r.chromosome, r.start, r.end, [{r.caller: r}])\n            for _, r in dataframe.iterrows()]\n\n\ndef combine_regions(one_regions, two_regions, allow_duplicates=False):\n    \"\"\"\n    Process 'one' and 'two' Region lists to generate combined Region list.\n\n    :param one_regions: First list of regions\n    :param two_regions: Second list of regions\n    :param allow_duplicates: Duplicate callers allowed in the region\n    :return: List of combined regions\n    \"\"\"\n    tail = None\n    regions = []\n    for region in sorted(one_regions + two_regions, key=repr):\n        if tail is None:\n            tail = region\n        else:\n            outs, tail = tail.intersect(region, allow_duplicates)\n            regions.extend(outs)\n\n    if tail is not None:\n        regions.append(tail)\n\n    return regions\n\n\ndef filter_regions(regions, caller):\n    \"\"\"\n    Filter out Region objects which don't contain caller in sources. Allows use\n    of a BED file for filtering.\n\n    :param regions: List of Regions to filter\n    :param caller: Caller needed for Region to be in output list\n    :return: List of Regions with caller present in sources\n    \"\"\"\n    return [r for r in regions if caller in r.sources]\n\n\ndef to_dataframe(regions, callers):\n    \"\"\"\n    Create a DataFrame from Regions list for given analysis and callers.\n\n    :param regions: List of Regions to process\n    :param callers: List of callers to take into account\n    :return: DataFrame with Region coordinates and data for each caller\n    \"\"\"\n    return pd.DataFrame((r.to_series(callers) for r in regions))\n\n\ndef to_dataframe_for_consensus(regions):\n    \"\"\"\n    Create a DataFrame from Regions list for consensus calling.\n\n    :param regions: List of Regions to process\n    :return: DataFrame with Region coordinates and consensus info\n    \"\"\"\n    columns = ['chromosome', 'start', 'end', 'status', 'confidence', 'support',\n               'freec_status', 'freec_genotype', 'freec_cn', 'freec_cn1',\n               'freec_cn2', 'gatk_status', 'gatk_cn', 'gatk_call',\n               'gatk_mean_log2_copy_ratio',\n               'gatk_minor_allele_fraction_posterior_50']\n    return pd.DataFrame((r.to_series_for_consensus() for r in regions))[columns]\n\n\ndef to_dataframe_for_gatk(regions):\n    \"\"\"\n    Create a DataFrame from Regions list for GATK cnLOH.\n\n    :param regions: List of Regions to process\n    :return: DataFrame with Region coordinates and GATK cnLOH info\n    \"\"\"\n    columns = ['chromosome', 'start', 'end', 'length', 'status', 'cn', 'cn1',\n               'cn2', 'call', 'mean_log2_copy_ratio',\n               'log2_copy_ratio_posterior_50',\n               'minor_allele_fraction_posterior50']\n    return pd.DataFrame((r.to_series_for_gatk() for r in regions))[columns]\n\n\ndef to_dataframe_for_sv(regions):\n    \"\"\"\n    Create a DataFrame from Regions list initiated from SVs.\n\n    :param regions: List of Regions to process\n    :return: DataFrame with Region coordinates and data for each caller\n    \"\"\"\n    return pd.DataFrame((r.to_series_for_sv() for r in regions))\n\n\ndef calculate_metrics(regions, tru_caller, que_caller, custom_metrics=False):\n    \"\"\"\n    Calculate metrics for given DataFrame.\n\n    :param regions: Regions to evaluate\n    :param tru_caller: Name of truth caller\n    :param que_caller: Name of caller to compare to truth caller\n    :param custom_metrics: If selected calculate TP, OE and UE only\n    :return: Series containing metrics\n    \"\"\"\n    metrics_columns = ['caller', 'total', 'tp', 'tn', 'fp', 'fn', 'oe', 'ue',\n                       'recall', 'fscore', 'precision']\n\n    custom_metrics_columns = ['caller', 'total', 'tp', 'oe', 'ue', 'tp_percent',\n                              'oe_percent', 'ue_percent']\n\n    tru_status = '{}_status'.format(tru_caller)\n    que_status = '{}_status'.format(que_caller)\n\n    if custom_metrics:\n        # Replace NaN in truth status with neutral\n        cond = regions[tru_status].isnull()\n        regions.loc[cond, tru_status] = 'neutral'\n\n        # Replace NaN in query status with neutral\n        cond = regions[que_status].isnull()\n        regions.loc[cond, que_status] = 'neutral'\n\n        cond_tp = regions[tru_status] == regions[que_status]\n        tp = regions[cond_tp].length.sum()\n\n        cond_tru_loss = regions[tru_status].astype(str) == 'loss'\n        cond_tru_neut = regions[tru_status].astype(str) == 'neutral'\n        cond_tru_gain = regions[tru_status].astype(str) == 'gain'\n        cond_que_loss = regions[que_status].astype(str) == 'loss'\n        cond_que_neut = regions[que_status].astype(str) == 'neutral'\n        cond_que_gain = regions[que_status].astype(str) == 'gain'\n\n        cond_oe = (cond_tru_loss & cond_que_neut) | (\n                cond_tru_loss & cond_que_gain) | (cond_tru_neut & cond_que_gain)\n        oe = regions[cond_oe].length.sum()\n\n        cond_ue = (cond_tru_gain & cond_que_neut) | (\n                cond_tru_gain & cond_que_loss) | (cond_tru_neut & cond_que_loss)\n        ue = regions[cond_ue].length.sum()\n\n        tp_percent = tp / (tp + oe + ue)\n        oe_percent = oe / (tp + oe + ue)\n        ue_percent = ue / (tp + oe + ue)\n\n        total = tp + oe + ue\n\n        return pd.Series(\n            [que_caller, total, tp, oe, ue, tp_percent, oe_percent, ue_percent],\n            index=custom_metrics_columns)\n\n    else:\n        # Replace neutral in truth status with NaN\n        cond = regions[tru_status] == 'neutral'\n        regions.loc[cond, tru_status] = np.NaN\n\n        # Replace neutral in query status with NaN\n        cond = regions[que_status] == 'neutral'\n        regions.loc[cond, que_status] = np.NaN\n\n        cond_tp = regions[tru_status] == regions[que_status]\n        tp = regions[cond_tp].length.sum()\n\n        cond_tn = regions[tru_status].isnull() & regions[que_status].isnull()\n        tn = regions[cond_tn].length.sum()\n\n        cond_fp = regions[tru_status].isnull() & regions[que_status].notnull()\n        fp = regions[cond_fp].length.sum()\n\n        cond_fn = regions[tru_status].notnull() & regions[que_status].isnull()\n        fn = regions[cond_fn].length.sum()\n\n        cond_oe = (regions[tru_status].astype(str) == 'loss') & (\n                regions[que_status].astype(str) == 'gain')\n        oe = regions[cond_oe].length.sum()\n\n        cond_ue = (regions[tru_status].astype(str) == 'gain') & (\n                regions[que_status].astype(str) == 'loss')\n        ue = regions[cond_ue].length.sum()\n\n        recall = tp / (tp + fn + oe + ue)\n        precision = tp / (tp + fp + oe + ue)\n        fscore = 0\n        if recall + precision != 0:\n            fscore = 2 * recall * precision / (recall + precision)\n\n        total = tp + tn + fp + fn + oe + ue\n\n        return pd.Series(\n            [que_caller, total, tp, tn, fp, fn, oe, ue, recall, fscore,\n             precision], index=metrics_columns)\n\n\ndef calculate_metrics_zare(truth, query, overlap_threshold=0.8):\n    \"\"\"\n    Calculate metrics using Zare et al. method for given DataFrame.\n\n    :param truth: Truth DataFrame\n    :param query: Query DataFrame\n    :param overlap_threshold: Same call if overlap greater than threshold\n    :return: Series containing metrics\n    \"\"\"\n\n    def compare_rows(row1, row2, overlap_threshold=0.8):\n        \"\"\"\n        Inline helper method.\n\n        :param row1: First row\n        :param row2: Second row\n        :param overlap_threshold: Same call if overlap greater than threshold\n        :return: True if same call and overlap > threshold\n        \"\"\"\n        chromosome = row1['chromosome'] == row2['chromosome']\n        status = row1['status'] == row2['status']\n        overlap = row1['start'] < row2['end'] and row1['end'] > row2['start']\n        intersection = min(row1['end'], row2['end']) - max(row1['start'],\n                                                           row2['start'])\n        union = max(row1['end'], row2['end']) - min(row1['start'],\n                                                    row2['start'])\n        overlap_enough = intersection / union > overlap_threshold\n\n        if chromosome and status and overlap and overlap_enough:\n            return True\n        else:\n            return False\n\n    zare_metrics_columns = ['caller', 'overlap_threshold', 'tt', 'fn', 'tp',\n                            'fp', 'tq', 'recall', 'fscore', 'precision']\n    que_caller = query['caller'].iloc[-1]\n\n    # tt - total truth calls\n    # tq - total query calls\n    # tp - true positives\n    # fn - false negatives (fn = tt - tp)\n    # fp - false positives (fp = tq - tp)\n\n    # Keep only loss and gain regions\n    # Truth\n    cond = truth['status'].isin(['loss', 'gain'])\n    truth = truth[cond]\n    # Query\n    cond = query['status'].isin(['loss', 'gain'])\n    query = query[cond]\n\n    tt = len(truth)\n    tq = len(query)\n\n    tp = sum((compare_rows(truth_row, query_row, overlap_threshold)\n              for _, truth_row\n              in truth.iterrows()\n              for _, query_row\n              in query[(query['chromosome'] == truth_row['chromosome']) &\n                       (query['status'] == truth_row['status']) &\n                       (query['start'] < truth_row['end']) &\n                       (query['end'] > truth_row['start'])].iterrows()))\n\n    fn = tt - tp\n    fp = tq - tp\n\n    recall = tp / tt\n    precision = 0\n    if tq != 0:\n        precision = tp / tq\n    fscore = 0\n    if recall + precision != 0:\n        fscore = 2 * recall * precision / (recall + precision)\n\n    return pd.Series(\n        [que_caller, overlap_threshold, tt, fn, tp, fp, tq, recall, fscore,\n         precision], index=zare_metrics_columns)\n\n\ndef powerset(iterable):\n    \"\"\"\n    Create all combinations of iterable's elements. Used for Venn analysis.\n\n    Example:\n    powerset([1,2,3]) --> (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)\n\n    :param iterable: List (iterable) of elements to combine\n    :return: Iterator of element combinations tuples\n    \"\"\"\n    s = list(iterable)  # allows duplicate elements\n    return chain.from_iterable(combinations(s, r) for r in range(1, len(s) + 1))\n\n\ndef venn(df, callers):\n    \"\"\"\n    Analyze congruence of all caller combinations. Find length of loss, neutral\n    and gain regions where each combination 'agrees'.\n\n    :param df: Combined regions DataFrame\n    :param callers: List of callers to analyze\n    :return: DataFrame containing results\n    \"\"\"\n    data = []\n\n    loss_conds = {}\n    neut_conds = {}\n    gain_conds = {}\n\n    for caller in callers:\n        status = '{}_status'.format(caller)\n        loss_conds[caller] = df[status].isin(['loss'])\n        neut_conds[caller] = df[status].isnull() | df[status].isin(['neutral'])\n        gain_conds[caller] = df[status].isin(['gain'])\n\n    for combo in powerset(callers):\n        row = {}\n        # Start with all True\n        loss_cond = df.chromosome == df.chromosome\n        neut_cond = df.chromosome == df.chromosome\n        gain_cond = df.chromosome == df.chromosome\n        for caller in callers:\n            if caller in combo:\n                row[caller] = 1\n                loss_cond = loss_cond & loss_conds[caller]\n                neut_cond = neut_cond & neut_conds[caller]\n                gain_cond = gain_cond & gain_conds[caller]\n            else:\n                row[caller] = 0\n                loss_cond = loss_cond & ~loss_conds[caller]\n                neut_cond = neut_cond & ~neut_conds[caller]\n                gain_cond = gain_cond & ~gain_conds[caller]\n\n        row['loss'] = sum(df[loss_cond].length)\n        row['neutral'] = sum(df[neut_cond].length)\n        row['gain'] = sum(df[gain_cond].length)\n\n        data.append(row)\n\n    return pd.DataFrame(data)"
              },
              {
                "filename": "cnv_converter.py",
                "fileContent": "from sbg_cveto_util import read_csv\nfrom sbg_cveto_util import init_logging\nimport argparse\nfrom enums import Callers, ChromosomeActions, ZeroOneCorrection, \\\n    ChromosomeCallersAction\nfrom enums import ZeroOneCorrectionCallers, CnvCallersClues\n\n\ndef sbg_converter(input_files, input_caller,\n                  auto_mode, name_tag,\n                  chromosome_action, zerone):\n    \"\"\"\n    Wrapper for auto_mode and file_transformation function. Can process\n    array of files.\n\n    :param input_files: Input CNV files\n    :param input_caller: Specified input caller for the group of files\n    :param auto_mode: Activate Auto Mode\n    :param name_tag: Desired name_tag. Default value: sbg_converted\n    :param chromosome_action: Apply chromosome annotation change, or not\n    :param zerone: Apply zero/one transformation, or not\n    :return:\n    \"\"\"\n    logger = init_logging('SBG_CNV_Converter',\n                          output_filename='sbg_converter.log')\n\n    if input_caller:\n        for item in input_files:\n            name = item.split('/').pop()\n            logger.info('START')\n            logger.info('Processing file {}'.format(name))\n\n            file_transformation(file=item,\n                                input_caller=input_caller,\n                                name_tag=name_tag,\n                                chromosome_action=chromosome_action,\n                                zerone=zerone)\n\n            logger.info('PROCESSED')\n\n    # AUTO MODE\n\n    elif not input_caller and auto_mode:\n\n        for item in input_files:\n            name = item.split('/').pop()\n            logger.info('START')\n            logger.info('Processing file {}'.format(name))\n\n            input_caller = run_auto_mode(file=item)\n            logger.info('Caller detected: {}'.format(input_caller))\n\n            file_transformation(file=item, input_caller=input_caller,\n                                name_tag=name_tag,\n                                chromosome_action=chromosome_action,\n                                zerone=zerone\n                                )\n\n            # print(input_caller)\n\n            logger.info('PROCESSED')\n\n\ndef run_auto_mode(file):\n    \"\"\"\n    Auto-mode. Detect cnv caller of the input file by header or distinct fields\n    and then call file_transformation function to apply conversion.\n\n    :param file: Input CNV file\n    :return: Detected caller of the input cnv file\n    \"\"\"\n\n    input_caller = ''\n    firstline = ''\n\n    for line in open(file, 'r').readlines():\n        if line.startswith('@') or line.startswith('#'):\n            continue\n        else:\n            firstline = line.rstrip()\n            break\n\n    # firstline = open(file, 'r').readline().rstrip()\n    first_line = firstline.split('\\t')\n    if len(first_line) > 1:\n        if first_line == CnvCallersClues.cnvkit:\n            input_caller = 'cnvkit'\n        elif first_line == CnvCallersClues.cnvkit_no_loh:\n            input_caller = 'cnvkit_no_loh'\n        elif first_line == CnvCallersClues.controlfreec:\n            input_caller = 'controlfreec'\n        elif first_line == CnvCallersClues.controlfreec_no_loh:\n            input_caller = 'controlfreec_no_loh'\n        elif first_line == CnvCallersClues.purecn_no_loh:\n            input_caller = 'purecn_no_loh'\n        elif first_line == CnvCallersClues.facets:\n            input_caller = 'facets'\n        elif first_line == CnvCallersClues.sequenza:\n            input_caller = 'sequenza'\n        elif first_line == CnvCallersClues.icr96:\n            input_caller = 'icr96'\n        elif first_line == CnvCallersClues.bed:\n            input_caller = 'bed'\n        elif first_line == CnvCallersClues.scnvsim:\n            input_caller = 'scnvsim'\n        elif first_line == CnvCallersClues.simulatecnvs:\n            input_caller = 'simulatecnvs'\n        elif first_line == CnvCallersClues.gatk:\n            input_caller = 'gatk_called'\n        elif first_line == CnvCallersClues.gatk_model_final:\n            input_caller = 'gatk_model'\n        elif first_line == CnvCallersClues.sbg_conseca_cnv:\n            input_caller = 'sbg_conseca_cnv'\n        elif len(first_line) == 3:\n            input_caller = 'bed'\n        elif first_line == CnvCallersClues.varsimlab:\n            input_caller = 'varsimlab'\n        elif first_line == CnvCallersClues.sveto_prepare:\n            input_caller = 'sveto_prep_cnv'\n        # no_header\n        # cnvnator\n        elif len(first_line[1].split(':')) > 1:\n            input_caller = 'cnvnator'\n        # controlfreec_no_loh\n        elif first_line[-1] in CnvCallersClues.controlfreec_no_header:\n            input_caller = 'controlfreec_no_loh_no_header'\n        # controlfreec\n        elif first_line[-3] in CnvCallersClues.controlfreec_no_header:\n            input_caller = 'controlfreec_no_header'\n    elif len(firstline.split(',')) > 1:\n        first_line = firstline.split(',')\n        if first_line == CnvCallersClues.purecn:\n            input_caller = 'purecn'\n\n    return input_caller\n\n\ndef file_transformation(file, input_caller, name_tag, chromosome_action,\n                        zerone):\n    \"\"\"\n    Apply file transformation and additional adjustments like chromosomes\n    annotation and zero-based, one-based correction as well as making\n    output file.\n\n    :param file: Input CNV file\n    :param input_caller: CNV caller that can be specified as the tool input or\n    inherithed from auto_mode function\n    :param name_tag: Desired output name tad. Default value: sbg_converted\n    :param chromosome_action: Apply chromosome annotation change, or not\n    :param zerone: Apply zero/one transformation, or not\n    \"\"\"\n    conv_df = read_csv(file,\n                       caller=name_tag,\n                       cnv_format=input_caller)\n\n    # ADD or REMOVE CHROMOSOME ANNOTATION IN OUTPUT FILES\n\n    if chromosome_action:\n        if input_caller in ChromosomeCallersAction.addchrom_callers and \\\n                str(chromosome_action) == 'add_chr':\n            conv_df['chromosome'] = 'chr' + conv_df[\n                'chromosome'].astype(str)\n        elif input_caller in ChromosomeCallersAction.removechrom_calers and \\\n                str(chromosome_action) == 'remove_chr':\n            conv_df['chromosome'] = conv_df[\n                'chromosome'].str.upper().str.replace(pat='CHR', repl='')\n\n    conv_df = conv_df.drop('caller', axis=1)\n\n    # ZERO-BASED, ONE-BASED Conversion\n\n    if zerone:\n        if str(zerone) == '1-based' and input_caller in \\\n                ZeroOneCorrectionCallers.zero_based_callers:\n            conv_df['start'] = conv_df['start'].astype(float) + 1\n        elif str(zerone) == '0-based' and input_caller in \\\n                ZeroOneCorrectionCallers.one_based_callers:\n            conv_df['start'] = conv_df['start'].astype(float) - 1\n        else:\n            raise Warning(\n                'Caller not listed in zero/one based caller list')\n\n    # OUTPUT\n    output_name = file.split('/').pop() + '.' + name_tag + '.cnv'\n\n    conv_df.to_csv(header=True, index=False, sep='\\t',\n                   path_or_buf='data_frame')\n\n    float_filtration('data_frame', output_name=output_name)\n\n\ndef float_filtration(file, output_name):\n    doc = open(file, 'r')\n\n    for line in doc:\n        first_line = line.rstrip('\\n')\n        break\n\n    cn_index = first_line.strip('\\n').split('\\t').index('cn')\n    cn1_index = first_line.strip('\\n').split('\\t').index('cn1')\n    cn2_index = first_line.strip('\\n').split('\\t').index('cn2')\n    status_index = first_line.strip('\\n').split('\\t').index('status')\n\n    doc_dict = {'chromosome': [], 'start': [], 'end': [], 'status': [],\n                'cn': [], 'cn1': [], 'cn2': []}\n\n    for line in doc:\n        lista = line.rstrip('\\n').split('\\t')\n        doc_dict['chromosome'].append(lista[0])\n        doc_dict['start'].append(lista[1].rstrip('0').rstrip('.'))\n        doc_dict['end'].append(lista[2].rstrip('0').rstrip('.'))\n        doc_dict['status'].append(lista[status_index])\n\n        if lista[cn_index] == '':\n            doc_dict['cn'].append('.')\n        else:\n            doc_dict['cn'].append(lista[cn_index].rstrip('0').rstrip('.'))\n\n        if lista[cn1_index] == '':\n            doc_dict['cn1'].append('.')\n        else:\n            doc_dict['cn1'].append(lista[cn1_index].rstrip('0').rstrip('.'))\n        if lista[cn2_index] == '':\n            doc_dict['cn2'].append('.')\n        else:\n            doc_dict['cn2'].append(lista[cn2_index].rstrip('0').rstrip('.'))\n\n    import sys\n    import os\n    orig_stdout = sys.stdout\n    f = open(output_name, 'w')\n    sys.stdout = f\n\n    print('chromosome\\tstart\\tend\\tcn\\tcn1\\tcn2\\tstatus')\n\n    for i in range(len(doc_dict['chromosome'])):\n            print('{}\\t{}\\t{}\\t{}\\t{}\\t{}\\t{}'.format(\n                doc_dict['chromosome'][i], doc_dict['start'][i],\n                doc_dict['end'][i], doc_dict['cn'][i], doc_dict['cn1'][i],\n                doc_dict['cn2'][i], doc_dict['status'][i]))\n    sys.stdout = orig_stdout\n    f.close()\n    os.remove(\"data_frame\")\n\n\ndef parse_arguments():\n    \"\"\"\n\n    :return:\n    \"\"\"\n    parser = argparse.ArgumentParser(\n        description=\"\"\n    )\n\n    # CNV files\n    parser.add_argument('-f',\n                        '--files',\n                        help='Input CNV files',\n                        nargs='+',\n                        required=True)\n\n    # CNV caller\n    parser.add_argument('-c',\n                        '--caller',\n                        help='Specify CNV caller',\n                        required=False,\n                        type=str)\n\n    # Auto-Mode\n    # parser.add_argument('-a',\n    #                    '--auto_mode',\n    #                    help='Auto-detect CNV caller',\n    #                    required=False,\n    #                    type=bool)\n\n    # File Tag\n    parser.add_argument('-t',\n                        '--tag',\n                        help='Specify Tag that will be added'\n                             ' to the output filename',\n                        required=False,\n                        default='sbg_converted',\n                        type=str)\n\n    # Remove CHR tag\n    parser.add_argument('-chr',\n                        '--chromosome_action',\n                        help='Remove or Add chr from chromosome annotation',\n                        required=False,\n                        default=False,\n                        type=ChromosomeActions,\n                        choices=list(ChromosomeActions)\n                        )\n\n    # Zero-One conversion\n    parser.add_argument('-zn',\n                        '-zerone',\n                        help='Make a conversion if tool outputs zero based'\n                             ' file but later you work with one-based'\n                             ' proccessing tools',\n                        required=False,\n                        default=False,\n                        type=ZeroOneCorrection,\n                        choices=list(ZeroOneCorrection)\n                        )\n\n    # Arguments\n\n    args = vars(parser.parse_args())\n\n    files = args['files']\n    caller = args['caller']\n    # auto = args['auto_mode']\n    name_tag = args['tag']\n    #\n    chromosome_action = args['chromosome_action']\n    zerone = args['zn']\n    #\n    auto = False\n    #\n    if not caller:\n        auto = True\n    if caller in Callers.callers:\n        pass\n    else:\n        ValueError('Specified caller is not supported by sbg_converter.'\n                   'Available options are: bed, cnvkit, cnvkit_no_loh,'\n                   'cnvnator, controlfreec, facets, icr96, purecn,'\n                   'purecn_no_loh, scnvsim, simulatecnvs, varsimlab,'\n                   'sveto_prep_cnv, controlfreec_no_header,'\n                   'controlfreec_no_loh_no_header,'\n                   'controlfreec_no_loh, sbg_conseca_cnv,'\n                   'gatk_called, gatk_model, sequenza')\n\n    return sbg_converter(input_files=files,\n                         input_caller=caller,\n                         auto_mode=auto,\n                         name_tag=name_tag,\n                         chromosome_action=chromosome_action,\n                         zerone=zerone\n                         )\n\n\nobj = parse_arguments()"
              },
              {
                "filename": "enums.py",
                "fileContent": "\"\"\"\nFile containing variables for sbg_converter script.\n\n\"\"\"\nfrom enum import Enum\n\n\nclass Callers:\n    callers = ['bed', 'cnvkit', 'cnvkit_no_loh', 'cnvnator', 'controlfreec',\n               'controlfreec_no_loh', 'controlfreec_no_header',\n               'controlfreec_no_loh_no_header', 'facets', 'gatk_called',\n               'icr96', 'purecn', 'purecn_no_loh', 'scnvsim', 'sequenza',\n               'simulatecnvs', 'varsimlab', 'sveto_prep_cnv',\n               'sbg_conseca_cnv',\n               'gatk_model']\n\n\nclass ZeroOneCorrectionCallers:\n    \"\"\"\n    List of callers.\n\n    control-freec   c++                 zero-based\n    facets          R\\c++               one-based\n    purecn          R                   one-based\n    cnvkit          python              zero-based\n    cnvnator        c++\\python\\perl     zero-based\n    sequenza        R                   one-based\n    gatk            java                zero-based\n    scnvsim         python/shell        zero-based\n    simulatecnvs    python              zero-based\n    icr96              -\n    varsimlab       java/python         zero-based\n    sveto_prep_cnv  python              zero-based\n    bed             python              zero-based\n    sbg_conseca_cnv python/gatk/freec   zero-based\n    \"\"\"\n\n    zero_based_callers = ['cnvkit_no_loh', 'cnvkit', 'controlfreec',\n                          'controlfreec_no_header',\n                          'controlfreec_no_loh_no_header',\n                          'controlfreec_no_loh',\n                          'cnvnator', 'gatk', 'scnvsim', 'simulatecnvs',\n                          'varsimlab',\n                          'sveto_prep_cnv', 'sbg_conseca_cnv']\n\n    one_based_callers = ['facets', 'purecn',\n                         'purecn_no_loh', 'sequenza']\n\n\nclass ChromosomeCallersAction:\n    addchrom_callers = ['facets', 'purecn', 'purecn_no_loh',\n                        'controlfreec', 'controlfreec_no_header',\n                        'controlfreec_no_loh_no_header',\n                        'controlfreec_no_loh', 'sbg_conseca_cnv']\n\n    removechrom_calers = ['bed', 'cnvkit', 'cnvkit_no_loh', 'cnvnator',\n                          'gatk', 'icr96', 'scnvsim', ' sequenza',\n                          'simulatecnvs', 'varsimlab', 'sveto_prep_cnv']\n\n\nclass ChromosomeActions(Enum):\n    remove_chr = 'remove_chr'\n    add_chr = 'add_chr'\n\n    def __str__(self):\n        return self.value\n\n\nclass ZeroOneCorrection(Enum):\n    one_based = '1-based'\n    zero_based = '0-based'\n\n    def __str__(self):\n        return self.value\n\n\nclass CnvCallersClues:\n    # CNVKIT\n\n    cnvkit_no_loh = ['chromosome', 'start', 'end', 'gene', 'log2', 'cn',\n                     'depth', 'probes', 'weight']\n\n    # cnvkit = ['chromosome', 'start', 'end', 'gene',\n    #  'log2', 'baf', 'cn', 'cn1',\n    #          'cn2', 'depth', 'probes', 'weight']\n    cnvkit = ['chromosome', 'start', 'end', 'gene', 'log2', 'probes',\n              'weight', 'baf', 'cn', 'cn1', 'cn2']\n\n    # FACETS\n\n    facets = ['chrom', 'seg', 'num.mark', 'nhet', 'cnlr.median', 'mafR',\n              'segclust', 'cnlr.median.clust', 'mafR.clust', 'start', 'end',\n              'cf.em', 'tcn.em', 'lcn.em']\n\n    # PURECN\n\n    purecn_no_loh = ['ID', 'chrom', 'loc.start', 'loc.end', 'num.mark',\n                     'seg.mean', 'C']\n\n    # PURECN with loh, splitted by semicolon\n\n    purecn = ['Sampleid', 'chr', 'start', 'end', 'arm', 'C', 'M', 'type']\n\n    # CONTROLFREEC - with header\n\n    controlfreec = ['chr', 'start', 'end', 'copy number', 'status', 'genotype',\n                    'uncertainty', 'WilcoxonRankSumTestPvalue',\n                    'KolmogorovSmirnovPvalue']\n\n    controlfreec_no_loh = ['chr', 'start', 'end', 'copy number', 'status',\n                           'WilcoxonRankSumTestPvalue',\n                           'KolmogorovSmirnovPvalue'\n                           ]\n\n    # CONTROLFREEC no header\n    \"\"\"\n        No need to add no_loh version because the same clue appears in the\n        different column.\n    \"\"\"\n\n    controlfreec_no_header = ['gain', 'loss', 'neutral']\n\n    # Sequenza\n\n    sequenza = ['chromosome', 'start.pos', 'end.pos', 'Bf', 'N.BAF', 'sd.BAF',\n                'depth.ratio', 'N.ratio', 'sd.ratio', 'CNt', 'A', 'B', 'LPP']\n\n    # ICR96\n\n    icr96 = ['chromosome', 'start', 'end', 'ExonCNVType']\n\n    # BED\n\n    bed = ['chromosome', 'start', 'end']\n\n    # SCNVSIM\n\n    scnvsim = ['chr', 'Start', 'End', 'Copy_Number']\n\n    # SIMUlATECNVS\n\n    simulatecnvs = ['chr', 'start', 'end', 'length', 'copy_number']\n\n    # GATK - call seg file\n\n    gatk = ['CONTIG', 'START', 'END',\n            'NUM_POINTS_COPY_RATIO', 'MEAN_LOG2_COPY_RATIO', 'CALL']\n\n    # GATK - model Final file\n\n    gatk_model_final = ['CONTIG', 'START', 'END', 'NUM_POINTS_COPY_RATIO',\n                        'NUM_POINTS_ALLELE_FRACTION',\n                        'LOG2_COPY_RATIO_POSTERIOR_10',\n                        'LOG2_COPY_RATIO_POSTERIOR_50',\n                        'LOG2_COPY_RATIO_POSTERIOR_90',\n                        'MINOR_ALLELE_FRACTION_POSTERIOR_10',\n                        'MINOR_ALLELE_FRACTION_POSTERIOR_50',\n                        'MINOR_ALLELE_FRACTION_POSTERIOR_90']\n\n    # ConsecaCNV\n\n    sbg_conseca_cnv = ['chromosome', 'start', 'end', 'status', 'confidence',\n                       'support', 'freec_status', 'freec_genotype', 'freec_cn',\n                       'freec_cn1', 'freec_cn2', 'gatk_status', 'gatk_cn',\n                       'gatk_call', 'gatk_mean_log2_copy_ratio',\n                       'gatk_minor_allele_fraction_posterior_50']\n\n    # BED - length of line split by tabs should be 3\n\n    # VARSIMLAB\n\n    varsimlab = ['chromosome', 'location', 'type', 'seq_size', 'CNV_size',\n                 'copies1', 'copies2', 'Npcent1', 'Npcent2']\n\n    # SVETO PREPARE\n\n    sveto_prepare = ['chromosome', 'start', 'end', 'status', 'cn',\n                     'cn1', 'cn2']"
              }
            ]
          }
        ],
        "inputs": [
          {
            "type": [
              "null",
              {
                "type": "enum",
                "name": "zerone",
                "symbols": [
                  "0-based",
                  "1-based"
                ]
              }
            ],
            "inputBinding": {
              "position": 4,
              "prefix": "-zn",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "ZeroOne Correction",
            "description": "Apply zero-one correction. This referes to translating coordinates of the resulting CNV file to a 1-based or 0-based system. If your CNV results are in a 0-based coordinate system, selecting the option '1-based' will translate them to a 1-based system. If your CNV results are in a 1-based coordinate system, selecting the option '0-based' will translate them to a 0-based coordinate system.",
            "id": "#zerone"
          },
          {
            "sbg:category": "Option",
            "type": [
              "null",
              "string"
            ],
            "inputBinding": {
              "position": 2,
              "prefix": "-t",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Name tag",
            "description": "If not specified tag will be sbg_converted.",
            "id": "#name_tag"
          },
          {
            "sbg:category": "Input",
            "sbg:stageInput": null,
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "inputBinding": {
              "position": 0,
              "prefix": "-f",
              "separate": true,
              "itemSeparator": " ",
              "sbg:cmdInclude": true
            },
            "label": "Input CNV files",
            "description": "Input CNV files",
            "id": "#input_files",
            "required": false
          },
          {
            "type": [
              "null",
              {
                "type": "enum",
                "symbols": [
                  "bed",
                  "cnvkit",
                  "cnvkit_no_loh",
                  "cnvnator",
                  "controlfreec",
                  "controlfreec_no_loh",
                  "controlfreec_no_header",
                  "controlfreec_no_header_no_loh",
                  "facets",
                  "gatk",
                  "icr96",
                  "purecn",
                  "purecn_no_loh",
                  "scnvsim",
                  "sequenza",
                  "simulatecnvs",
                  "varsimlab",
                  "sveto_prep_cnv"
                ],
                "name": "input_caller"
              }
            ],
            "inputBinding": {
              "position": 1,
              "prefix": "-c",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Input CNV caller",
            "description": "Specify input CNV caller",
            "id": "#input_caller"
          },
          {
            "type": [
              "null",
              {
                "type": "enum",
                "name": "chr",
                "symbols": [
                  "remove_chr",
                  "add_chr"
                ]
              }
            ],
            "inputBinding": {
              "position": 3,
              "prefix": "-chr",
              "separate": true,
              "sbg:cmdInclude": true
            },
            "label": "Add or remove chromosome tag",
            "description": "Add or remove the 'chr' prefix in the CNV results. Currently, this best serves purpose if you are supplying CNV results by Control-FREEC, and combining them with VCF that have 'chr' in chromosome names, as Control-FREEC (by design) always outputs results without 'chr', even if the reference FASTA stated otherwise.",
            "id": "#chr"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              {
                "type": "array",
                "items": "File"
              }
            ],
            "label": "Output CNV files",
            "description": "Converted files",
            "outputBinding": {
              "glob": "*.cnv",
              "sbg:inheritMetadataFrom": "#input_files"
            },
            "id": "#converted_files"
          }
        ],
        "hints": [
          {
            "class": "sbg:CPURequirement",
            "value": 1
          },
          {
            "class": "sbg:MemRequirement",
            "value": 1000
          },
          {
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/vtomic/sveto:2.0"
          }
        ],
        "baseCommand": [
          "python3",
          "cnv_converter.py"
        ],
        "stdin": "",
        "stdout": "",
        "successCodes": [],
        "temporaryFailCodes": [],
        "arguments": [],
        "cwlVersion": "sbg:draft-2",
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "sbg:projectName": "SBGTools - Demo New",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565622816,
            "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/11"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565624868,
            "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/12"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565693539,
            "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/13"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565694570,
            "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/14"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565710640,
            "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/16"
          }
        ],
        "sbg:image_url": null,
        "sbg:job": {
          "inputs": {
            "input_files": [
              {
                "path": "/path/to/input_files-1.ext",
                "class": "File",
                "size": 0,
                "secondaryFiles": []
              },
              {
                "path": "/path/to/input_files-2.ext",
                "class": "File",
                "size": 0,
                "secondaryFiles": []
              }
            ],
            "input_caller": "bed",
            "name_tag": "name_tag-string-value",
            "chr": "remove_chr",
            "zerone": "0-based"
          },
          "allocatedResources": {
            "cpu": 1,
            "mem": 1000
          }
        },
        "sbg:cmdPreview": "python3 cnv_converter.py",
        "sbg:toolkit": "SBGtools",
        "sbg:toolkitVersion": "1.0",
        "sbg:toolAuthor": "Seven Bridges",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "bix-demo/sbgtools-demo/sbg-cnv-converter/4",
        "sbg:id": "bix-demo/sbgtools-demo/sbg-cnv-converter/4",
        "sbg:revision": 4,
        "sbg:revisionNotes": "Copy of vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/16",
        "sbg:modifiedOn": 1565710640,
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:createdOn": 1565622816,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "bix-demo/sbgtools-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "sbg:latestRevision": 4,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a9a10c02c2568db7693d488da0ae78d82cfcfe736e0952cbb5a01b8cf925f52bc",
        "sbg:copyOf": "vojislav_varjacic/sbg-cnv-converter/sbg-cnv-converter/16",
        "x": 451.5170127467105,
        "y": 575.8826326069079
      },
      "inputs": [
        {
          "id": "#SBG_CNV_Converter.zerone",
          "default": "1-based"
        },
        {
          "id": "#SBG_CNV_Converter.name_tag"
        },
        {
          "id": "#SBG_CNV_Converter.input_files",
          "source": [
            "#copyNumberCalls"
          ]
        },
        {
          "id": "#SBG_CNV_Converter.input_caller",
          "source": [
            "#input_caller"
          ]
        },
        {
          "id": "#SBG_CNV_Converter.chr",
          "source": [
            "#chr"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#SBG_CNV_Converter.converted_files"
        }
      ],
      "sbg:x": 451.5170127467105,
      "sbg:y": 575.8826326069079,
      "scatter": "#SBG_CNV_Converter.input_files"
    },
    {
      "id": "#VCFtools_Subset",
      "run": {
        "class": "CommandLineTool",
        "label": "VCFtools Subset",
        "description": "VCFtools subset removes specified columns from the VCF file.",
        "requirements": [
          {
            "engineCommand": "cwl-engine.js",
            "class": "ExpressionEngineRequirement",
            "id": "#cwl-js-engine",
            "requirements": [
              {
                "class": "DockerRequirement",
                "dockerPull": "rabix/js-engine"
              }
            ]
          },
          {
            "class": "CreateFileRequirement",
            "fileDef": [
              {
                "filename": "get_tumor_name.py",
                "fileContent": "import argparse\n\nparser = argparse.ArgumentParser(description='This tool outputs the tumor name column from a VCF file.')\nparser.add_argument('-i','--input', help='Input VCF file', required=True)\nparser.add_argument('-s','--sample_id', help='Sample_id metadata')\nparser.add_argument('-col','--column', help='Column to be parsed')\nargs = vars(parser.parse_args())\n\nvcf_file = args['input']\nsample_id = args['sample_id']\ncolumn = args['column']\n\nif (column == \"Left\"):\n\tcol = -2\nelif (column == \"Right\"):\n\tcol = -1\nelse:\n\tcol = 'ERROR'\n\ntmp = False\nwith open(vcf_file) as f:\n\tfor line in f:\n\t\tif line[0:6]=='#CHROM':\n\t\t\tx = line.split('\\t')\n\t\t\tflag = False\n\t\t\tsamples = x[-2:]\n\t\t\tsamples = [s.rstrip() for s in samples]\n\t\t\t\n\t\t\tfor s in samples:\n\t\t\t\tif 'tumor' in s.lower():\n\t\t\t\t\ttumor_name = s\n\t\t\t\t\tflag = True\n\t\t\tif flag:  \n\t\t\t\tbreak\n\t\t\telse:\n\t\t\t\tif sample_id != 'none':\n\t\t\t\t\tfor sample in samples:\n\t\t\t\t\t\tif sample_id in sample:\n\t\t\t\t\t\t\ttumor_name = sample\n\t\t\t\t\t\t\ttmp = True\n\t\t\t\t\t\t\tbreak\n\t\t\t\t\t\n\t\t\t\t\tif not tmp:\n\t\t\t\t\t\ttumor_name = x[col]\n\t\t\t\t\t\tbreak\n\t\t\t\telse:\n\t\t\t\t\ttumor_name = x[col]\n\t\t\t\t\tbreak\n\t\t\tbreak\n\nprint (tumor_name.rstrip())"
              }
            ]
          }
        ],
        "inputs": [
          {
            "description": "Print only rows where only the subset columns carry an alternate allele.",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 4,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-p"
            },
            "id": "#private",
            "label": "Private",
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "FALSE"
          },
          {
            "description": "Proceed anyway even if VCF does not contain some of the samples.",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 3,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-f"
            },
            "id": "#force",
            "label": "Force execution",
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "FALSE"
          },
          {
            "description": "Exclude rows not containing variants.",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 2,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-e"
            },
            "id": "#exclude_rows",
            "label": "Exclude rows not containing variants",
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "FALSE"
          },
          {
            "description": "Remove alternate alleles if not found in the subset.",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 0,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-a"
            },
            "id": "#trim_alternate_alleles",
            "label": "Trim alternate alleles",
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "FALSE"
          },
          {
            "type": [
              {
                "type": "array",
                "name": "input_files",
                "items": "File"
              }
            ],
            "description": "Input files (vcf, vcf.gz).",
            "inputBinding": {
              "position": 100,
              "separate": false,
              "sbg:cmdInclude": true,
              "itemSeparator": null
            },
            "id": "#input_files",
            "label": "Input files",
            "sbg:category": "File Input",
            "sbg:fileTypes": "VCF, VCF.GZ"
          },
          {
            "description": "Do not exclude rows without calls.",
            "type": [
              "null",
              "boolean"
            ],
            "inputBinding": {
              "position": 8,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-u"
            },
            "id": "#uncalled",
            "label": "Uncalled",
            "sbg:category": "Execution",
            "sbg:toolDefaultValue": "FALSE"
          },
          {
            "description": "File or comma-separated list of columns to keep in the vcf file. If file, one column per row.",
            "type": [
              "null",
              {
                "type": "array",
                "items": "string"
              }
            ],
            "inputBinding": {
              "valueFrom": {
                "class": "Expression",
                "script": "{\n  if ($job.inputs.columns) {\n    return $job.inputs.columns \n  } else {\n    return \"$tmp\"\n  }\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:cmdInclude": true,
              "position": 1,
              "separate": true,
              "prefix": "-c",
              "itemSeparator": ","
            },
            "id": "#columns",
            "label": "Comma separated list of columns",
            "sbg:category": "Execution"
          },
          {
            "type": [
              "null",
              "boolean"
            ],
            "description": "Replace the excluded types with reference allele instead of dot.",
            "inputBinding": {
              "position": 5,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-r"
            },
            "id": "#replace_with_ref",
            "sbg:stageInput": null,
            "label": "Replace with reference",
            "sbg:category": "Execution"
          },
          {
            "type": [
              "null",
              {
                "type": "array",
                "items": "string"
              }
            ],
            "description": "Comma-separated list of variant types to include: ref,SNPs,indels,MNPs,other.",
            "inputBinding": {
              "position": 7,
              "separate": true,
              "sbg:cmdInclude": true,
              "prefix": "-t",
              "itemSeparator": ","
            },
            "id": "#types",
            "sbg:stageInput": null,
            "label": "List of variant types",
            "sbg:category": "Execution"
          },
          {
            "type": [
              "null",
              {
                "type": "enum",
                "name": "column",
                "symbols": [
                  "Left",
                  "Right"
                ]
              }
            ],
            "description": "Sample column to be parsed if there is no tumor sample or sample ID provided. If your VCF has two columns (a normal and a tumor column), and the pipeline does not automatically infer which is the tumor column, please select here whether it's the right or the left one.",
            "id": "#column",
            "label": "VCF tumor column name",
            "sbg:toolDefaultValue": "None",
            "sbg:category": "VCF options"
          }
        ],
        "outputs": [
          {
            "type": [
              "null",
              "File"
            ],
            "description": "Output file satisfying the subset criteria.",
            "id": "#output_file",
            "label": "Output file",
            "outputBinding": {
              "glob": {
                "class": "Expression",
                "script": "{\n  inp = $job.inputs.input_files\n  inp = [].concat( inp );\n  \n  if (inp.length > 1) {\n     sufix = \"and_more.subset\"\n  } else {\n     sufix = \"subset\"\n  }\n  \n  sufix_ext = \"vcf\";\n  filepath = inp[0].path\n  filename = filepath.split(\"/\").pop()\n  \n  if (filename.lastIndexOf(\".vcf.gz\") != -1) {\n    basename = filename.substr(0,filename.lastIndexOf(\".vcf.gz\"))\n  } else {\n    basename = filename.substr(0,filename.lastIndexOf(\".\"))\n  }\n\n  new_filename = basename + \".\" + sufix + \".\" + sufix_ext;\n  \n  return new_filename;\n}",
                "engine": "#cwl-js-engine"
              },
              "sbg:inheritMetadataFrom": "#input_files"
            },
            "sbg:fileTypes": "VCF"
          }
        ],
        "hints": [
          {
            "dockerImageId": "54cb823ba25a",
            "class": "DockerRequirement",
            "dockerPull": "images.sbgenomics.com/ognjenm/vcftools:0.1.14"
          },
          {
            "value": 1,
            "class": "sbg:CPURequirement"
          },
          {
            "value": 1000,
            "class": "sbg:MemRequirement"
          }
        ],
        "baseCommand": [
          {
            "class": "Expression",
            "script": "{\n  var x = [].concat($job.inputs.input_files)[0].path\n  cmd = ''\n  if (x.toLowerCase().endsWith('gz')) {\n    for (i=0;i<[].concat($job.inputs.input_files).length;i++) {\n      cmd +='gzip -dkf ' + [].concat($job.inputs.input_files)[i].path + ' && '\n    }\n  }\n  return cmd\n}",
            "engine": "#cwl-js-engine"
          },
          {
            "class": "Expression",
            "script": "{\n  var x = [].concat($job.inputs.input_files)[0].path\n  if (x.toLowerCase().endsWith('gz')) {\n    var vcf = [].concat($job.inputs.input_files)[0].path.slice(0,-3)\n  } else {\n    var vcf = [].concat($job.inputs.input_files)[0].path\n  }\n  \n  if ($job.inputs.column){\n    var col = \" -col \" + $job.inputs.column\n  } else {\n    var col = \"\" \n  }\n  \n  if ([].concat($job.inputs.input_files)[0].metadata && [].concat($job.inputs.input_files)[0].metadata.sample_id) {\n    var sample_id = [].concat($job.inputs.input_files)[0].metadata.sample_id\n  } else {\n    var sample_id = 'none'\n  }\n  return \"tmp=$(python get_tumor_name.py -i \" + vcf + \" -s \" + sample_id + col +\") && \"\n    //return $job.inputs.column\n}",
            "engine": "#cwl-js-engine"
          },
          "vcf-subset"
        ],
        "stdin": "",
        "stdout": {
          "class": "Expression",
          "script": "{\n  inp = $job.inputs.input_files\n  inp = [].concat( inp );\n  \n  if (inp.length > 1) {\n     sufix = \"and_more.subset\"\n  } else {\n     sufix = \"subset\"\n  }\n  \n  sufix_ext = \"vcf\";\n  filepath = inp[0].path\n  filename = filepath.split(\"/\").pop()\n  \n  if (filename.lastIndexOf(\".vcf.gz\") != -1) {\n    basename = filename.substr(0,filename.lastIndexOf(\".vcf.gz\"))\n  } else {\n    basename = filename.substr(0,filename.lastIndexOf(\".\"))\n  }\n\n  new_filename = basename + \".\" + sufix + \".\" + sufix_ext;\n  \n  return new_filename;\n}",
          "engine": "#cwl-js-engine"
        },
        "successCodes": [],
        "temporaryFailCodes": [],
        "arguments": [],
        "$namespaces": {
          "sbg": "https://sevenbridges.com"
        },
        "sbg:image_url": null,
        "sbg:cmdPreview": "gzip -dkf /path/to/sample1.vcf.gz &&  tmp=$(python get_tumor_name.py -i /path/to/sample1.vcf -s SAMPLE) &&  vcf-subset /path/to/sample1.vcf.gz > sample1.subset.vcf",
        "sbg:revisionsInfo": [
          {
            "sbg:revision": 0,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1511791776,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/12"
          },
          {
            "sbg:revision": 1,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1520519991,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/13"
          },
          {
            "sbg:revision": 2,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1523887855,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/14"
          },
          {
            "sbg:revision": 3,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1523897381,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/15"
          },
          {
            "sbg:revision": 4,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1523902699,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/16"
          },
          {
            "sbg:revision": 5,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526399897,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/17"
          },
          {
            "sbg:revision": 6,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526405004,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/18"
          },
          {
            "sbg:revision": 7,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1526469183,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/19"
          },
          {
            "sbg:revision": 8,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1529083507,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/20"
          },
          {
            "sbg:revision": 9,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1529268712,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/21"
          },
          {
            "sbg:revision": 10,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565966610,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/22"
          },
          {
            "sbg:revision": 11,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565966750,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/23"
          },
          {
            "sbg:revision": 12,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1565966901,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/24"
          },
          {
            "sbg:revision": 13,
            "sbg:modifiedBy": "uros_sipetic",
            "sbg:modifiedOn": 1566296609,
            "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/25"
          }
        ],
        "sbg:projectName": "Tumor Heterogeneity SciClone-based Workflow - Demo",
        "sbg:job": {
          "inputs": {
            "column": null,
            "replace_with_ref": false,
            "columns": null,
            "input_files": [
              {
                "class": "File",
                "metadata": {
                  "sample_id": "SAMPLE"
                },
                "path": "/path/to/sample1.vcf.gz",
                "secondaryFiles": [],
                "size": 0
              }
            ],
            "types": null
          },
          "allocatedResources": {
            "mem": 1000,
            "cpu": 1
          }
        },
        "sbg:toolkitVersion": "0.1.14",
        "sbg:categories": [
          "VCF-Processing"
        ],
        "cwlVersion": "sbg:draft-2",
        "sbg:license": "GNU General Public License version 3.0 (GPLv3)",
        "sbg:links": [
          {
            "label": "Homepage",
            "id": "https://vcftools.github.io"
          },
          {
            "label": "Source code",
            "id": "https://github.com/vcftools/vcftools"
          },
          {
            "label": "Publications",
            "id": "http://bioinformatics.oxfordjournals.org/content/27/15/2156"
          },
          {
            "label": "Download",
            "id": "https://github.com/vcftools/vcftools/zipball/master"
          },
          {
            "label": "Wiki",
            "id": "https://sourceforge.net/p/vcftools/wiki/Home/"
          }
        ],
        "sbg:toolkit": "VCFtools",
        "sbg:toolAuthor": "Adam Auton, Petr Danecek, Anthony Marcketta",
        "sbg:appVersion": [
          "sbg:draft-2"
        ],
        "id": "https://api.sbgenomics.com/v2/apps/uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo/vcftools-subset-0-1-14/13/raw/",
        "sbg:id": "uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo/vcftools-subset-0-1-14/13",
        "sbg:revision": 13,
        "sbg:revisionNotes": "Copy of uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/25",
        "sbg:modifiedOn": 1566296609,
        "sbg:modifiedBy": "uros_sipetic",
        "sbg:createdOn": 1511791776,
        "sbg:createdBy": "uros_sipetic",
        "sbg:project": "uros_sipetic/tumor-heterogeneity-sciclone-based-workflow-demo",
        "sbg:sbgMaintained": false,
        "sbg:validationErrors": [],
        "sbg:contributors": [
          "uros_sipetic"
        ],
        "sbg:latestRevision": 13,
        "sbg:publisher": "sbg",
        "sbg:content_hash": "a6894d2b69b16f569f3dffaf677b5a2fdf850b97ecc266039d0e9e8f397925057",
        "sbg:copyOf": "uros_sipetic/bms-rna-tools/vcftools-subset-0-1-14/25"
      },
      "inputs": [
        {
          "id": "#VCFtools_Subset.private"
        },
        {
          "id": "#VCFtools_Subset.force"
        },
        {
          "id": "#VCFtools_Subset.exclude_rows"
        },
        {
          "id": "#VCFtools_Subset.trim_alternate_alleles"
        },
        {
          "id": "#VCFtools_Subset.input_files",
          "source": [
            "#vcf_files"
          ]
        },
        {
          "id": "#VCFtools_Subset.uncalled",
          "default": true
        },
        {
          "id": "#VCFtools_Subset.columns"
        },
        {
          "id": "#VCFtools_Subset.replace_with_ref"
        },
        {
          "id": "#VCFtools_Subset.types"
        },
        {
          "id": "#VCFtools_Subset.column",
          "source": [
            "#column"
          ]
        }
      ],
      "outputs": [
        {
          "id": "#VCFtools_Subset.output_file"
        }
      ],
      "sbg:x": -650.9091019568485,
      "sbg:y": 332.90912834832864,
      "scatter": "#VCFtools_Subset.input_files"
    }
  ],
  "requirements": [],
  "inputs": [
    {
      "label": "VCF files",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "VCF, VCF.GZ",
      "sbg:y": 332.51974998822607,
      "type": [
        {
          "items": "File",
          "type": "array"
        }
      ],
      "description": "VCF files, obtained from somatic calling analysis.",
      "id": "#vcf_files",
      "sbg:x": -884.2872306474396
    },
    {
      "sbg:y": 429.6925571986609,
      "label": "Tumor BAM files",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "BAM",
      "secondaryFiles": [
        ".bai"
      ],
      "type": [
        "null",
        {
          "items": "File",
          "type": "array"
        }
      ],
      "description": "BAM files for the accompanying tumor samples. Only needed if multiple samples are provided to the workflow.",
      "id": "#bams",
      "sbg:x": 451.8810163225448
    },
    {
      "label": "Copy number calls",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "CNV, CNS, TXT",
      "sbg:y": 575.0551565069901,
      "type": [
        "null",
        {
          "items": "File",
          "type": "array"
        }
      ],
      "description": "Copy number information, in a tab-delimited format, obtained from a CNV-calling analysis (with tools like CNVkit for example).",
      "id": "#copyNumberCalls",
      "sbg:x": 226.2620464124178
    },
    {
      "label": "GTF file",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "GTF",
      "sbg:y": 582.1961593627931,
      "type": [
        "null",
        "File"
      ],
      "description": "Gene annotation file.",
      "id": "#gtf",
      "sbg:x": 1462.3828506469729
    },
    {
      "label": "Known cancer genes",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "VCF, TXT",
      "sbg:y": 63.823638916015625,
      "type": [
        "null",
        "File"
      ],
      "description": "Known cancer database, like COSMIC.",
      "id": "#known_cancer_genes",
      "sbg:x": 1447.5692138671875
    },
    {
      "label": "Project ID",
      "sbg:includeInPorts": true,
      "sbg:y": 564.6426827566967,
      "type": [
        "null",
        "string"
      ],
      "description": "Project ID, to be added to the report.",
      "id": "#project_id",
      "sbg:x": 919.1071428571432
    },
    {
      "label": "copyNumberMargins",
      "sbg:includeInPorts": true,
      "sbg:y": 695.0000000000002,
      "type": [
        "null",
        "float"
      ],
      "description": "In order to identify cleanly copy-number neutral regions, sciClone only considers sites with a copy number of 2.0 +/- this value. For example, if set to 0.25 (which is the default value), regions at 2.20 will be considered cn-neutral and regions at 2.30 will be not.",
      "id": "#copyNumberMargins",
      "sbg:x": 645.1784842354914
    },
    {
      "label": "useSexChrs",
      "sbg:includeInPorts": true,
      "sbg:y": 162.49997138977054,
      "type": [
        "null",
        {
          "symbols": [
            "TRUE",
            "FALSE"
          ],
          "name": "useSexChrs",
          "type": "enum"
        }
      ],
      "description": "Option to choose whether to use sex chromosomes in the sciClone clustering procedure (by default, this option is turned on).",
      "id": "#useSexChrs",
      "sbg:x": 648.7499618530275
    },
    {
      "label": "Output naming",
      "sbg:includeInPorts": true,
      "sbg:y": 157.14276994977683,
      "type": [
        "null",
        {
          "symbols": [
            "Type1",
            "Type2"
          ],
          "name": "output_naming",
          "type": "enum"
        }
      ],
      "description": "Output naming convention. Type1: normal.tumor; Type2: tumor-normal.",
      "id": "#output_naming",
      "sbg:x": 912.857099260603
    },
    {
      "label": "Report format",
      "sbg:suggestedValue": "version_2",
      "type": [
        {
          "symbols": [
            "version_1",
            "version_2",
            "cancer_version"
          ],
          "name": "report_type",
          "type": "enum"
        }
      ],
      "description": "Format of the report to be outputted.",
      "id": "#report_type",
      "sbg:category": "Inputs"
    },
    {
      "label": "Report name",
      "sbg:toolDefaultValue": "Inferred from input filename",
      "id": "#report_name",
      "description": "Name of the output report",
      "type": [
        "null",
        "string"
      ],
      "sbg:category": "Inputs"
    },
    {
      "sbg:category": "Inputs",
      "id": "#vaf_threshold",
      "label": "VAF threshold",
      "type": [
        "null",
        "float"
      ],
      "sbg:toolDefaultValue": "70",
      "description": "Lines with VAF values above this threshold will be written to the file with regions to exclude from SciClone analysis.",
      "sbg:suggestedValue": 60
    },
    {
      "label": "Sample order",
      "sbg:toolDefaultValue": "Alphabetical order",
      "id": "#sample_order",
      "description": "List here the order of the sequenced samples, by adding string values of sample IDs (or VCF filenames) in their chronological order (if you add filenames, the sample IDs must be contained in their respective filenames). There should be as much as rows as there are samples/VCFs used in the sciClone analysis. This is important for downstream analysis with tools like Fishplot, which are used to infer the evolution of the tumor. If only one sample is being processed with sciClone, this input is not needed. If multiple sample are being processed, but this input is not provided (or the number of samples specified is not the as the number of input samples), the samples will be sorted alphabetically.",
      "type": [
        "null",
        {
          "items": "string",
          "type": "array"
        }
      ],
      "sbg:category": "Arguments"
    },
    {
      "label": "Copy numbers in log2 format",
      "sbg:stageInput": null,
      "sbg:toolDefaultValue": "False",
      "type": [
        "null",
        "boolean"
      ],
      "description": "Boolean argument specifying whether or not the copy number predictions are in log2 format (as opposed to being absolute copy number designations).",
      "id": "#cnCallsAreLog2",
      "sbg:category": "Arguments"
    },
    {
      "label": "Cluster method",
      "sbg:stageInput": null,
      "sbg:toolDefaultValue": "bmm",
      "type": [
        "null",
        {
          "symbols": [
            "bmm",
            "gaussian.bmm",
            "binomial.bmm"
          ],
          "name": "clusterMethod",
          "type": "enum"
        }
      ],
      "description": "Use a different distribution for clustering. Currently supported options are 'bmm' for beta, 'gaussian.bmm' for gaussian and 'binomial.bmm' for binomial.",
      "id": "#clusterMethod",
      "sbg:category": "Arguments",
      "sbg:suggestedValue": "binomial.bmm"
    },
    {
      "type": [
        "null",
        "int"
      ],
      "label": "Read depth resolution",
      "id": "#read_resolution",
      "inputBinding": {
        "prefix": "-rd_res",
        "separate": true,
        "position": 35,
        "sbg:cmdInclude": true
      },
      "description": "Amount by which read required read depth will be lowered in each cycle in order to optimize the parameters.",
      "sbg:category": "Settings"
    },
    {
      "type": [
        "null",
        "int"
      ],
      "label": "Read depth cutoff",
      "description": "Minimum read depth required to pass the filter.",
      "sbg:toolDefaultValue": "80",
      "inputBinding": {
        "prefix": "-read_depth",
        "separate": true,
        "position": 25,
        "sbg:cmdInclude": true
      },
      "id": "#input_read_depth",
      "sbg:category": "Settings",
      "sbg:suggestedValue": 80
    },
    {
      "type": [
        "null",
        "int"
      ],
      "label": "Number of clusters",
      "description": "The number of clusters that SciClone needs to be able to achieve.",
      "sbg:toolDefaultValue": "10",
      "inputBinding": {
        "prefix": "-max_clust",
        "separate": true,
        "position": 20,
        "sbg:cmdInclude": true
      },
      "id": "#input_max_clust",
      "sbg:category": "Settings"
    },
    {
      "type": [
        "null",
        {
          "type": "enum",
          "symbols": [
            "bed",
            "cnvkit",
            "cnvkit_no_loh",
            "cnvnator",
            "controlfreec",
            "controlfreec_no_loh",
            "controlfreec_no_header",
            "controlfreec_no_header_no_loh",
            "facets",
            "gatk",
            "icr96",
            "purecn",
            "purecn_no_loh",
            "scnvsim",
            "sequenza",
            "simulatecnvs",
            "varsimlab",
            "sveto_prep_cnv"
          ],
          "name": "input_caller"
        }
      ],
      "inputBinding": {
        "position": 1,
        "prefix": "-c",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "Input CNV caller",
      "description": "Specify input CNV caller",
      "id": "#input_caller"
    },
    {
      "type": [
        "null",
        {
          "type": "enum",
          "name": "chr",
          "symbols": [
            "remove_chr",
            "add_chr"
          ]
        }
      ],
      "inputBinding": {
        "position": 3,
        "prefix": "-chr",
        "separate": true,
        "sbg:cmdInclude": true
      },
      "label": "Add or remove chromosome tag",
      "description": "Add or remove the 'chr' prefix in the CNV results. Currently, this best serves purpose if you are supplying CNV results by Control-FREEC, and combining them with VCF that have 'chr' in chromosome names, as Control-FREEC (by design) always outputs results without 'chr', even if the reference FASTA stated otherwise.",
      "id": "#chr"
    },
    {
      "type": [
        "null",
        {
          "type": "enum",
          "name": "column",
          "symbols": [
            "Left",
            "Right"
          ]
        }
      ],
      "description": "Sample column to be parsed if there is no tumor sample or sample ID provided. If your VCF has two columns (a normal and a tumor column), and the pipeline does not automatically infer which is the tumor column, please select here whether it's the right or the left one.",
      "id": "#column",
      "label": "VCF tumor column name",
      "sbg:toolDefaultValue": "None",
      "sbg:category": "VCF options"
    }
  ],
  "outputs": [
    {
      "label": "SciClone plots",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "PDF, GIF",
      "sbg:y": 64.15945434570312,
      "type": [
        "null",
        {
          "items": "File",
          "type": "array"
        }
      ],
      "required": false,
      "description": "Plots containing sub-clonality informations.",
      "id": "#sciclone_plots",
      "sbg:x": 1329.3001708984375,
      "source": [
        "#SciClone_1_1.sciclone_plots"
      ]
    },
    {
      "label": "Cluster summary",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TXT, SUMMARY",
      "sbg:y": 422.4999442994614,
      "type": [
        "null",
        {
          "items": "File",
          "type": "array"
        }
      ],
      "required": false,
      "description": "Cluster summaries (cluster centers).",
      "id": "#clusterSummary",
      "sbg:x": 1319.999799251564,
      "source": [
        "#SciClone_1_1.clusterSummary"
      ]
    },
    {
      "label": "Tumor heterogeneity report",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TXT, CSV",
      "sbg:y": 422.4998832643088,
      "type": [
        "null",
        "File"
      ],
      "required": false,
      "description": "A report containing information about the tumor samples (purity, MATH scores, cluster means and number of mutations per cluster).",
      "id": "#tumor_heterogeneity_report",
      "sbg:x": 1461.2495467663032,
      "source": [
        "#SBG_SciClone_report.tumor_heterogeneity_report"
      ]
    },
    {
      "label": "SciClone clusters",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TXT, CLUSTERS",
      "sbg:y": 211.425722871677,
      "type": [
        "null",
        "File"
      ],
      "required": false,
      "description": "File containing clusters information.",
      "id": "#clusters",
      "sbg:x": 1446.9325309435956,
      "source": [
        "#SciClone_1_1.clusters"
      ]
    },
    {
      "label": "ClonEvol plots",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "PDF, PNG",
      "sbg:y": 182.6199340820313,
      "type": [
        "null",
        {
          "items": "File",
          "type": "array"
        }
      ],
      "required": false,
      "description": "All plots outputted by ClonEvol.",
      "id": "#clonevol_plots",
      "sbg:x": 1820.2223423549112,
      "source": [
        "#ClonEvol_0_1.clonevol_plots"
      ]
    },
    {
      "label": "Fishplot plots",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "PDF",
      "sbg:y": 422.11425781250017,
      "type": [
        "null",
        "File"
      ],
      "required": false,
      "description": "Plots outputted by Fishplot.",
      "id": "#fishplot_plots",
      "sbg:x": 2012.1601213727686,
      "source": [
        "#Fishplot_0_3.fishplot_plots"
      ]
    },
    {
      "label": "Tumor purity",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TXT",
      "sbg:y": 211.24992614984882,
      "type": [
        "null",
        "File"
      ],
      "required": false,
      "description": "Estimated tumor purity for the sample. The estimation is done by analyzing peaks in the kernel density of the main cluster (the one around 50%) and then multiplying that value by two. This file produced only if one sample is provided to the workflow. If multiple samples are provided, for purity information, please look at the Tumor Heterogeneity Report output.",
      "id": "#purity",
      "sbg:x": 1331.2496763616948,
      "source": [
        "#SciClone_1_1.purity"
      ]
    },
    {
      "label": "Clonal Evolution Models",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TXT",
      "sbg:y": 576.9642857142859,
      "type": [
        "null",
        "File"
      ],
      "required": false,
      "description": "Clonal evolution models, represented in a text tile. Each line is a different model and can be interpreted as follow: the order of number represents number of the subclone (cluster, as inferred by sciClone), and the value of the number is the parent clone from which that clone originated.",
      "id": "#clonal_evolution_models",
      "sbg:x": 2007.8571428571436,
      "source": [
        "#Fishplot_0_3.clonal_evolution_models"
      ]
    },
    {
      "label": "Tumor Heterogeneity Results",
      "sbg:includeInPorts": true,
      "sbg:fileTypes": "TAR, TAR.GZ, TAR.BZ2, GZ, BZ2, ZIP",
      "sbg:y": 324.64270455496666,
      "type": [
        "File"
      ],
      "required": true,
      "description": "All files outputted by the Tumor Heterogeneity workflow, bundles in a single archive.",
      "id": "#tumor_heterogeneity_results",
      "sbg:x": 2493.9274379185276,
      "source": [
        "#SBG_Compressor.output_archives"
      ]
    }
  ],
  "sbg:canvas_y": -137,
  "sbg:toolkitVersion": "",
  "sbg:toolkit": "",
  "sbg:links": [
    {
      "label": "SciClone Homepage",
      "id": "https://github.com/genome/sciclone"
    },
    {
      "label": "SciClone Publication",
      "id": "http://journals.plos.org/ploscompbiol/article/asset?id=10.1371%2Fjournal.pcbi.1003665.PDF"
    },
    {
      "label": "ClonEvol Homepage",
      "id": "https://github.com/hdng/clonevol"
    },
    {
      "label": "Fishplot Homepage",
      "id": "https://github.com/chrisamiller/fishplot"
    },
    {
      "label": "Fishplot Publication",
      "id": "http://biorxiv.org/content/biorxiv/early/2016/06/15/059055.full.pdf"
    }
  ],
  "sbg:toolAuthor": "Seven Bridges Genomics",
  "sbg:categories": [
    "Tumor-Heterogeneity"
  ],
  "sbg:license": "GNU General Public License v3.0 only",
  "sbg:canvas_x": 1114,
  "sbg:canvas_zoom": 0.95,
  "sbg:projectName": "BMS Tumor Heterogeneity - Dev",
  "sbg:revisionsInfo": [
    {
      "sbg:revision": 0,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1481651071,
      "sbg:revisionNotes": "Copy of ognjenm/sciclone-benchmarking/sciclone-wf/8"
    },
    {
      "sbg:revision": 1,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1481651071,
      "sbg:revisionNotes": "Copy of uros_sipetic/bms-tumor-heterogeneity/sciclone-workflow/1"
    },
    {
      "sbg:revision": 2,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1481651071,
      "sbg:revisionNotes": "Copy of uros_sipetic/bms-tumor-heterogeneity/sciclone-workflow/2"
    },
    {
      "sbg:revision": 3,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1481651071,
      "sbg:revisionNotes": "Copy of uros_sipetic/bms-tumor-heterogeneity/sciclone-workflow/3"
    },
    {
      "sbg:revision": 4,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485189383,
      "sbg:revisionNotes": "Add support for multiple samples."
    },
    {
      "sbg:revision": 5,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485196204,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 6,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485196775,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 7,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485197452,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 8,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485197792,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 9,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485256748,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 10,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485273612,
      "sbg:revisionNotes": "Add support for Strelka in SBG SciClone VCF parser."
    },
    {
      "sbg:revision": 11,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485276282,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 12,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485278355,
      "sbg:revisionNotes": "Automate VCFtools subsetting."
    },
    {
      "sbg:revision": 13,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485285301,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 14,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485288244,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 15,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485293045,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 16,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485293529,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 17,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485294296,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 18,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485298452,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 19,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485342330,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 20,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485351726,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 21,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485361788,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 22,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485532561,
      "sbg:revisionNotes": "Add vaf output, remember to remove it"
    },
    {
      "sbg:revision": 23,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485533973,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 24,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485949337,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 25,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485949597,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 26,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485950221,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 27,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485950679,
      "sbg:revisionNotes": "Update SciClone."
    },
    {
      "sbg:revision": 28,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485952866,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 29,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485956146,
      "sbg:revisionNotes": "Add estimated tumor purity as output."
    },
    {
      "sbg:revision": 30,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485957611,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 31,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485959457,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 32,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485959543,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 33,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1485960676,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 34,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486044909,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 35,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486045221,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 36,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486045916,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 37,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486046577,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 38,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486052612,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 39,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486056067,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 40,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486063461,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 41,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1486492619,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 42,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1491832346,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 43,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493215923,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 44,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493220142,
      "sbg:revisionNotes": "add vcf sort"
    },
    {
      "sbg:revision": 45,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493221496,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 46,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493223164,
      "sbg:revisionNotes": "add vcftools keep snps"
    },
    {
      "sbg:revision": 47,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493226988,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 48,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493228879,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 49,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493230716,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 50,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1493373078,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 51,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494246128,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 52,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494247326,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 53,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494348975,
      "sbg:revisionNotes": "Add proper support for TNHaplotyper."
    },
    {
      "sbg:revision": 54,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494435740,
      "sbg:revisionNotes": "Add proper support for germline haplotypers."
    },
    {
      "sbg:revision": 55,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494437494,
      "sbg:revisionNotes": "Add proper support for germline haplotype callers (sentieon and gatk)."
    },
    {
      "sbg:revision": 56,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1494516361,
      "sbg:revisionNotes": "Fix rare bug in cases where there are no reads reported that align to a certain locus, yet the mutation is present in the vcf."
    },
    {
      "sbg:revision": 57,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1496050180,
      "sbg:revisionNotes": "Bump some tools to newest revisions."
    },
    {
      "sbg:revision": 58,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1496318645,
      "sbg:revisionNotes": "Update purity calculation."
    },
    {
      "sbg:revision": 59,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1496320964,
      "sbg:revisionNotes": "Update purity calculation."
    },
    {
      "sbg:revision": 60,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1497547218,
      "sbg:revisionNotes": "Update sciClone to make sure VAF and CNV files are properly paired."
    },
    {
      "sbg:revision": 61,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1497975225,
      "sbg:revisionNotes": "Expose different workflow options."
    },
    {
      "sbg:revision": 62,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498039956,
      "sbg:revisionNotes": "For VCF parser, format field for caller sniffing is queried through the header instead of the actual format fields, which can sometimes miss certain keys."
    },
    {
      "sbg:revision": 63,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498057203,
      "sbg:revisionNotes": "Add automatic CNVkit CN column recognition."
    },
    {
      "sbg:revision": 64,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498059238,
      "sbg:revisionNotes": "CNVkit input files should work now regardless of the CNVkit workflow version."
    },
    {
      "sbg:revision": 65,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498067820,
      "sbg:revisionNotes": "Add BCF Filter to keep only mutations with 'PASS' and '.' FILTER."
    },
    {
      "sbg:revision": 66,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498068483,
      "sbg:revisionNotes": "Set scatter on Bcftools Filter."
    },
    {
      "sbg:revision": 67,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498483575,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 68,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498484507,
      "sbg:revisionNotes": "Add SBG SciClone Parameters."
    },
    {
      "sbg:revision": 69,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498490181,
      "sbg:revisionNotes": "Add SBG SciClone report. Remove individual purity and cluster info files, as that info is now all present in the tumor_heterogeneity_report.txt file."
    },
    {
      "sbg:revision": 70,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498490572,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 71,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498491050,
      "sbg:revisionNotes": "Update SBG SciClone parameters."
    },
    {
      "sbg:revision": 72,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498491637,
      "sbg:revisionNotes": "Update SBG Sciclone Parameters and workflow description."
    },
    {
      "sbg:revision": 73,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498497130,
      "sbg:revisionNotes": "Update SBG SciClone Parameters."
    },
    {
      "sbg:revision": 74,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498500083,
      "sbg:revisionNotes": "Update SBG SciClone report."
    },
    {
      "sbg:revision": 75,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498500445,
      "sbg:revisionNotes": "Update description."
    },
    {
      "sbg:revision": 76,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498502923,
      "sbg:revisionNotes": "Update ClonEvol & Fishplot."
    },
    {
      "sbg:revision": 77,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498504153,
      "sbg:revisionNotes": "Update ClonEvol and Fishplot."
    },
    {
      "sbg:revision": 78,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498504848,
      "sbg:revisionNotes": "Update Fishplot."
    },
    {
      "sbg:revision": 79,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498505091,
      "sbg:revisionNotes": "Update Fishplot."
    },
    {
      "sbg:revision": 80,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498566665,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 81,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498566739,
      "sbg:revisionNotes": "Update sciClone to not print out purity estimated by it's own method of looking at cluster peaks, at the value is always 100."
    },
    {
      "sbg:revision": 82,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498567786,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 83,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498570307,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 84,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498571243,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 85,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498572900,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 86,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498573891,
      "sbg:revisionNotes": "Update VCFtools Subset."
    },
    {
      "sbg:revision": 87,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498574688,
      "sbg:revisionNotes": "Update VCFtools subset."
    },
    {
      "sbg:revision": 88,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498576717,
      "sbg:revisionNotes": "Update SBG SciClone Parameters."
    },
    {
      "sbg:revision": 89,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498583614,
      "sbg:revisionNotes": "Remove SBG SciClone parameters and SBG SciClone Report."
    },
    {
      "sbg:revision": 90,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1498583735,
      "sbg:revisionNotes": "Update description."
    },
    {
      "sbg:revision": 91,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1499272685,
      "sbg:revisionNotes": "Add proper metadata inheritance."
    },
    {
      "sbg:revision": 92,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1501074814,
      "sbg:revisionNotes": "Full version, with metadata inheritance fix."
    },
    {
      "sbg:revision": 93,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1501675771,
      "sbg:revisionNotes": "Update VCF parser to work with multiple samples properly."
    },
    {
      "sbg:revision": 94,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1501681446,
      "sbg:revisionNotes": "Update VCF parser to properly inherit sample_id metadata."
    },
    {
      "sbg:revision": 95,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1501684714,
      "sbg:revisionNotes": "Update VCF parser for proper regions output metadata sample_id inheritance."
    },
    {
      "sbg:revision": 96,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1501767597,
      "sbg:revisionNotes": "Update ClonEvol to fix a renaming expression."
    },
    {
      "sbg:revision": 97,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1502451069,
      "sbg:revisionNotes": "Update SBG SciClone Parameters."
    },
    {
      "sbg:revision": 98,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1507659778,
      "sbg:revisionNotes": "Update sciClone parser to match bams by sample_ids"
    },
    {
      "sbg:revision": 99,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1507659933,
      "sbg:revisionNotes": "expose vaf_threshold back"
    },
    {
      "sbg:revision": 100,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1507661098,
      "sbg:revisionNotes": "parser update"
    },
    {
      "sbg:revision": 101,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509228696,
      "sbg:revisionNotes": "Update report format"
    },
    {
      "sbg:revision": 102,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509230429,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 103,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509565305,
      "sbg:revisionNotes": "Update all of the main tools to change output naming (normal.tumor.ext)"
    },
    {
      "sbg:revision": 104,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509650138,
      "sbg:revisionNotes": "Update parser and report tools"
    },
    {
      "sbg:revision": 105,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509650660,
      "sbg:revisionNotes": "update sciclone"
    },
    {
      "sbg:revision": 106,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509663941,
      "sbg:revisionNotes": "Update report"
    },
    {
      "sbg:revision": 107,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509666690,
      "sbg:revisionNotes": "Update tools"
    },
    {
      "sbg:revision": 108,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509964198,
      "sbg:revisionNotes": "Add an archive of all results as an output"
    },
    {
      "sbg:revision": 109,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1509964251,
      "sbg:revisionNotes": "Update output archive name"
    },
    {
      "sbg:revision": 110,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510229560,
      "sbg:revisionNotes": "Update description."
    },
    {
      "sbg:revision": 111,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510327283,
      "sbg:revisionNotes": "Add an api script example to the description."
    },
    {
      "sbg:revision": 112,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510334960,
      "sbg:revisionNotes": "Use tools from demo projects"
    },
    {
      "sbg:revision": 113,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510335623,
      "sbg:revisionNotes": "Update BCFtools"
    },
    {
      "sbg:revision": 114,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510761661,
      "sbg:revisionNotes": "Add scatter where it needs to be"
    },
    {
      "sbg:revision": 115,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510846881,
      "sbg:revisionNotes": "Update SBG SciClone Parameters."
    },
    {
      "sbg:revision": 116,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510851059,
      "sbg:revisionNotes": "Revert back to the previous version (without the param tool update)."
    },
    {
      "sbg:revision": 117,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510913225,
      "sbg:revisionNotes": "Add description for input (test)."
    },
    {
      "sbg:revision": 118,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1510914295,
      "sbg:revisionNotes": "Add description for all inputs/outputs."
    },
    {
      "sbg:revision": 119,
      "sbg:modifiedBy": "anamijalkovic",
      "sbg:modifiedOn": 1510936745,
      "sbg:revisionNotes": "Updated description"
    },
    {
      "sbg:revision": 120,
      "sbg:modifiedBy": "anamijalkovic",
      "sbg:modifiedOn": 1510937039,
      "sbg:revisionNotes": "Updaed description"
    },
    {
      "sbg:revision": 121,
      "sbg:modifiedBy": "anamijalkovic",
      "sbg:modifiedOn": 1510937089,
      "sbg:revisionNotes": "Updated descritpion"
    },
    {
      "sbg:revision": 122,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511220050,
      "sbg:revisionNotes": "Update description."
    },
    {
      "sbg:revision": 123,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511284147,
      "sbg:revisionNotes": "Update SBG SciClone Parameters (rewritten in python)."
    },
    {
      "sbg:revision": 124,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511297074,
      "sbg:revisionNotes": "Update SBG Compressor to use recursion in the flattening expression."
    },
    {
      "sbg:revision": 125,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511309415,
      "sbg:revisionNotes": "Update sciClone to produce additional logs"
    },
    {
      "sbg:revision": 126,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511310958,
      "sbg:revisionNotes": "Fix typo in SBG SciClone Parameters."
    },
    {
      "sbg:revision": 127,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511311137,
      "sbg:revisionNotes": "Remove trimmed.trees output from ClonEvol."
    },
    {
      "sbg:revision": 128,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511312737,
      "sbg:revisionNotes": "Add default value on cnv_caller input"
    },
    {
      "sbg:revision": 129,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511314914,
      "sbg:revisionNotes": "Update SciClone and ClonEvol."
    },
    {
      "sbg:revision": 130,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511316409,
      "sbg:revisionNotes": "Update sciclone to remove stdout_log"
    },
    {
      "sbg:revision": 131,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511318016,
      "sbg:revisionNotes": "Add default value back on cnv_type input."
    },
    {
      "sbg:revision": 132,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511318083,
      "sbg:revisionNotes": "properly add default value on cnv_type input."
    },
    {
      "sbg:revision": 133,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511318281,
      "sbg:revisionNotes": "again properly set the default value for cnv_caller input"
    },
    {
      "sbg:revision": 134,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511343375,
      "sbg:revisionNotes": "Update output archive default filename"
    },
    {
      "sbg:revision": 135,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511348862,
      "sbg:revisionNotes": "Update SBG sciClone Parameters"
    },
    {
      "sbg:revision": 136,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511363534,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 137,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511369774,
      "sbg:revisionNotes": "Update SBG Compressor."
    },
    {
      "sbg:revision": 138,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511371708,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 139,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511389548,
      "sbg:revisionNotes": "Update description to include part about sorting samples chronologically."
    },
    {
      "sbg:revision": 140,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511389576,
      "sbg:revisionNotes": "Fix typos in description."
    },
    {
      "sbg:revision": 141,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511392383,
      "sbg:revisionNotes": "Update output archive name to include caller information if available."
    },
    {
      "sbg:revision": 142,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511393909,
      "sbg:revisionNotes": "Update purity_output description."
    },
    {
      "sbg:revision": 143,
      "sbg:modifiedBy": "aleksandar.mihajlovic",
      "sbg:modifiedOn": 1511440030,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 144,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511478366,
      "sbg:revisionNotes": "Update sciClone"
    },
    {
      "sbg:revision": 145,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511557894,
      "sbg:revisionNotes": "Update description (add part about properly paring VCFs with CNV/BAM files)."
    },
    {
      "sbg:revision": 146,
      "sbg:modifiedBy": "anamijalkovic",
      "sbg:modifiedOn": 1511775012,
      "sbg:revisionNotes": "descritpion"
    },
    {
      "sbg:revision": 147,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511792251,
      "sbg:revisionNotes": "Use VCFtools subset & SBGcompressor from the demo project"
    },
    {
      "sbg:revision": 148,
      "sbg:modifiedBy": "anamijalkovic",
      "sbg:modifiedOn": 1511860742,
      "sbg:revisionNotes": "Updated description"
    },
    {
      "sbg:revision": 149,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511862051,
      "sbg:revisionNotes": "Update description and category tags."
    },
    {
      "sbg:revision": 150,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1511862645,
      "sbg:revisionNotes": "Small description update."
    },
    {
      "sbg:revision": 151,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1512400309,
      "sbg:revisionNotes": "Minor changes"
    },
    {
      "sbg:revision": 152,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1516107627,
      "sbg:revisionNotes": "Update SciClone Parameters to properly work without CNV inputs"
    },
    {
      "sbg:revision": 153,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1516960928,
      "sbg:revisionNotes": "Update sciClone to add 'number_of_samples' metadata on the '*.clusters' output file."
    },
    {
      "sbg:revision": 154,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1516962056,
      "sbg:revisionNotes": "Update SBG Compressor to better name output in different cases of single/multiple samples provided."
    },
    {
      "sbg:revision": 155,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1516962433,
      "sbg:revisionNotes": "Update SBG compressor output glob"
    },
    {
      "sbg:revision": 156,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1516966707,
      "sbg:revisionNotes": "Update SBG Compressor to have proper glob output"
    },
    {
      "sbg:revision": 157,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1517826478,
      "sbg:revisionNotes": "Change report output format to tsv (from csv)"
    },
    {
      "sbg:revision": 158,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1517927749,
      "sbg:revisionNotes": "Update sciClone report to properly catch .tsv output"
    },
    {
      "sbg:revision": 159,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1518551225,
      "sbg:revisionNotes": "Add a text output with clonal evolution models."
    },
    {
      "sbg:revision": 160,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1518551406,
      "sbg:revisionNotes": "Add clonal evolution models to the output archive"
    },
    {
      "sbg:revision": 161,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1518559081,
      "sbg:revisionNotes": "update sciclone report tool"
    },
    {
      "sbg:revision": 162,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1518559115,
      "sbg:revisionNotes": "Update fishplot"
    },
    {
      "sbg:revision": 163,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1520520510,
      "sbg:revisionNotes": "Update sciclone report to include number of mutations per clone"
    },
    {
      "sbg:revision": 164,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1520599801,
      "sbg:revisionNotes": "Update VCF parser to include more callers."
    },
    {
      "sbg:revision": 165,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1522685493,
      "sbg:revisionNotes": "Update sciClone to better parse CNV column for CNVkit"
    },
    {
      "sbg:revision": 166,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1522686185,
      "sbg:revisionNotes": "Minor description changes"
    },
    {
      "sbg:revision": 167,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523887985,
      "sbg:revisionNotes": "Update VCFtools Subset"
    },
    {
      "sbg:revision": 168,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523897576,
      "sbg:revisionNotes": "Update vcftools subset"
    },
    {
      "sbg:revision": 169,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523902784,
      "sbg:revisionNotes": "Update vcftools subset"
    },
    {
      "sbg:revision": 170,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523910472,
      "sbg:revisionNotes": "Update SBG compressor"
    },
    {
      "sbg:revision": 171,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523914051,
      "sbg:revisionNotes": "Update SBG Compressor"
    },
    {
      "sbg:revision": 172,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1523962520,
      "sbg:revisionNotes": "Update sciclone parser to include normal_id metadata"
    },
    {
      "sbg:revision": 173,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526316744,
      "sbg:revisionNotes": "Add the parameter to include sex chromosome inside optimal sciclone parameters detection tool"
    },
    {
      "sbg:revision": 174,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526317043,
      "sbg:revisionNotes": "Update description."
    },
    {
      "sbg:revision": 175,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526318337,
      "sbg:revisionNotes": "Revert to 172"
    },
    {
      "sbg:revision": 176,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526319354,
      "sbg:revisionNotes": "Reconnect inputs"
    },
    {
      "sbg:revision": 177,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526387946,
      "sbg:revisionNotes": "Add recognition of additional callers to output file names"
    },
    {
      "sbg:revision": 178,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526399966,
      "sbg:revisionNotes": "Update VCFtools Subset to be more general in matching sample_ids"
    },
    {
      "sbg:revision": 179,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526405080,
      "sbg:revisionNotes": "Update VCFtools subset to fix a small bug"
    },
    {
      "sbg:revision": 180,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526469505,
      "sbg:revisionNotes": "Update VCFtools subset to allow for gzipped VCF files."
    },
    {
      "sbg:revision": 181,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526470474,
      "sbg:revisionNotes": "Lower EBS"
    },
    {
      "sbg:revision": 182,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526892436,
      "sbg:revisionNotes": "Update sciClone (add sciclone error log) and ClonEvol (improve detection of multiple samples)."
    },
    {
      "sbg:revision": 183,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526892584,
      "sbg:revisionNotes": "Set EBS to 200GB"
    },
    {
      "sbg:revision": 184,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526932375,
      "sbg:revisionNotes": "Update sciClone to remove 3d plots"
    },
    {
      "sbg:revision": 185,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1526988230,
      "sbg:revisionNotes": "Add VCFtools KeepSNPs"
    },
    {
      "sbg:revision": 186,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1527009703,
      "sbg:revisionNotes": "Update VCF Reheader, sciClone Parser, ClonEvol, Fishplot"
    },
    {
      "sbg:revision": 187,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1527168139,
      "sbg:revisionNotes": "Update vcf parser to fix small bug"
    },
    {
      "sbg:revision": 188,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528134172,
      "sbg:revisionNotes": null
    },
    {
      "sbg:revision": 189,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528140303,
      "sbg:revisionNotes": "Update sciClone"
    },
    {
      "sbg:revision": 190,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528189169,
      "sbg:revisionNotes": "Update some description"
    },
    {
      "sbg:revision": 191,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528198357,
      "sbg:revisionNotes": "Update sciClone"
    },
    {
      "sbg:revision": 192,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528205874,
      "sbg:revisionNotes": "Update sciClone Parameters tool"
    },
    {
      "sbg:revision": 193,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528211322,
      "sbg:revisionNotes": "Update scClone parameters, and small descriptions fixes"
    },
    {
      "sbg:revision": 194,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528242081,
      "sbg:revisionNotes": "Update VCF parser with updated variant_caller output metadata"
    },
    {
      "sbg:revision": 195,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528299390,
      "sbg:revisionNotes": "Update SBG Compressor to handle namings with multi-normal multi-tumor files"
    },
    {
      "sbg:revision": 196,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528977207,
      "sbg:revisionNotes": "Update sciClone parameters"
    },
    {
      "sbg:revision": 197,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1528986730,
      "sbg:revisionNotes": "Update sciClone to fix bug with flattening regions"
    },
    {
      "sbg:revision": 198,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1529083596,
      "sbg:revisionNotes": "Update VCFtools subset to force decompression of gzipped VCF files"
    },
    {
      "sbg:revision": 199,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1529248593,
      "sbg:revisionNotes": "Update VCF parser"
    },
    {
      "sbg:revision": 200,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1529268792,
      "sbg:revisionNotes": "Update VCFtools Subset to work well with tumor-only samples"
    },
    {
      "sbg:revision": 201,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1530104276,
      "sbg:revisionNotes": "Update sciClone Parameters"
    },
    {
      "sbg:revision": 202,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1533302908,
      "sbg:revisionNotes": "Update sciClone parameters to properly handle WGS data"
    },
    {
      "sbg:revision": 203,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1533571103,
      "sbg:revisionNotes": "Update vcf parser - multiallelic fix (for vardict)"
    },
    {
      "sbg:revision": 204,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1534187613,
      "sbg:revisionNotes": "Add output_naming option"
    },
    {
      "sbg:revision": 205,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1534189980,
      "sbg:revisionNotes": "Update sbg_compressor"
    },
    {
      "sbg:revision": 206,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1544704184,
      "sbg:revisionNotes": "Add ALI Instance Hint"
    },
    {
      "sbg:revision": 207,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1545867401,
      "sbg:revisionNotes": "Update docker image on sciclone parameters"
    },
    {
      "sbg:revision": 208,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1545926821,
      "sbg:revisionNotes": "Update docker image on SBG Get LOH Regions"
    },
    {
      "sbg:revision": 209,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1548428928,
      "sbg:revisionNotes": "Inputs should be sorted alphabetically by default now."
    },
    {
      "sbg:revision": 210,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1548430160,
      "sbg:revisionNotes": "Update sciclone params output name"
    },
    {
      "sbg:revision": 211,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1548784483,
      "sbg:revisionNotes": "Update sciclone to fix error logs"
    },
    {
      "sbg:revision": 212,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1548787470,
      "sbg:revisionNotes": "Update scilone savelogs feature"
    },
    {
      "sbg:revision": 213,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1561127644,
      "sbg:revisionNotes": "Add google instance hint"
    },
    {
      "sbg:revision": 214,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565624668,
      "sbg:revisionNotes": "Add CNV Converter"
    },
    {
      "sbg:revision": 215,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565624921,
      "sbg:revisionNotes": "Update CNV converter description."
    },
    {
      "sbg:revision": 216,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565627174,
      "sbg:revisionNotes": "Expose CNV caller"
    },
    {
      "sbg:revision": 217,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565629407,
      "sbg:revisionNotes": "Scatter CNV converter"
    },
    {
      "sbg:revision": 218,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565631090,
      "sbg:revisionNotes": "Flatten CNV inputs to SciClone and SciClone Parameters tools"
    },
    {
      "sbg:revision": 219,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565631655,
      "sbg:revisionNotes": "Update sciClone params (fix flattening expression)"
    },
    {
      "sbg:revision": 220,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565693886,
      "sbg:revisionNotes": "Update Description and CNV converter"
    },
    {
      "sbg:revision": 221,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565694588,
      "sbg:revisionNotes": "Update CNV converter"
    },
    {
      "sbg:revision": 222,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565710701,
      "sbg:revisionNotes": "Update CNV converter"
    },
    {
      "sbg:revision": 223,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1565966942,
      "sbg:revisionNotes": "Update VCFtools subset (expose VCF column selector)"
    },
    {
      "sbg:revision": 224,
      "sbg:modifiedBy": "uros_sipetic",
      "sbg:modifiedOn": 1566296640,
      "sbg:revisionNotes": "Update VCFtools Subset"
    }
  ],
  "sbg:image_url": "https://igor.sbgenomics.com/ns/brood/images/uros_sipetic/bms-tumor-heterogeneity-dev/sciclone-workflow/224.png",
  "label": "Tumor Heterogeneity SciClone-based workflow",
  "description": "The **Tumor Heterogeneity SciClone-based workflow** infers the heterogeneity of a tumor sample for WES or WGS data. \n\nA tumor usually consists of a founding clone and a number of subclones that are each characterized by different mutations that give rise to the heterogeneity of the tumor sample. Having proper insight into which mutations are specific to which subclone is important in designing effective treatment strategies.\n\nThe main approach with this workflow is based on clustering patterns of allele frequencies at somatic point mutations. The idea is that variant allele frequencies (VAFs) will group around 50% for any heterozygous somatic mutations  in copy-number neutral regions. Any other points clustering at regions with VAFs less than 50% would essentially represent subclones that arose later in the tumors evolution (because less reads aligning to these mutations indicate different cells sequenced in the bulk-sequencing experiment).\n\nThe approach with the variant allele frequencies is described in detail in the __sciClone__ paper, [1] and as a solution for this problem, __sciClone__ is used as the main tool in this Tumor heterogeneity workflow. __sciClone__ results are then further processed by tools such as __CloneEvol__ and __Fishplot__ to produce additional plots that describe the structure of the tumor. \n\n*A list of **all inputs and parameters** with corresponding descriptions can be found at the end of the page.*\n\n### Common Use Cases\n\n- The Tumor Heterogeneity workflow takes a VCF file obtained from any of the somatic callers as the main input (on the **VCF files** input). In order to increase the precision of the results, clustering should only be performed in copy-number neutral regions [1]. As such, copy-number calling results obtained from a copy number calling tool like **CNVkit** or **Control-FREEC**, can be provided to the workflow as an optional (but highly-recommended) input (on the **Copy number calls** input). The pairing of VCF samples and copy-number data is done by properly filling in the **Sample ID** metadata values.\n- The workflow will produce a set of results describing the heterogeneity of the tumor samples, including the information about the number of clusters and which cluster each mutation belongs to (**SciClone clusters**), different plots showing the clustering of mutations (**SciClone plots**) and tracking the the tumor's evolution (**ClonEvol plots** && **Fishplot plots**), as well as a report with more detailed information about the clustering process, like cluster mean information, the read depth threshold used, as well as the estimated tumor purity (**Tumor heterogeneity report**). \n- The workflow can work with multiple VCF files (multiple samples per one case, if tracking the evolution of a tumor, for example), but in that case accompanying BAM files for each sample should also be provided. In the case of only one sample, a BAM file is not required. The pairing of VCF samples and BAM files is done by properly filling in the **Sample ID** metadata values.\n- When working with multiple samples, it is usually of interest to preserve the chronological order of sequenced samples, so that the tumor's evolution can properly be tracked by downstream tools such as **ClonEvol** and **Fishplot**. To achieve this, the parameter **Sample Order** can be used by adding string values of **Sample IDs** (or VCF filenames) in their proper chronological order (if adding filenames, the sample IDs must be contained in their respective filenames). There should be as much as rows as there are samples/VCFs used in the **sciClone** analysis. If only one sample is being processed with **sciClone**, this input is not needed. If multiple sample are being processed, but this input is not provided (or the number of samples specified is not the as the number of input samples), the samples will be sorted alphabetically.\n\n### Changes Introduced by Seven Bridges\n\n- The **sciClone** tool will fail if not enough mutations are present for the clustering procedure. There is a parameter inside the tool which can control minimum read depth of the mutations used for clustering (**Minimum read depth** -\n default value is 80 in the workflow). To avoid failure the value for this parameter is determined in the workflow before **sciClone** itself by checking if enough mutations are present for clustering, and if not - the tool will iteratively lower down the minimum read depth by a fixed resolution (**Read depth resolution** parameter) until enough mutations are present. The determined value for the minimum read depth is then written to the output **Tumor heterogeneity report**. This value is calculated by the **SBG SciClone Parameters** tool, and is then passed into the **sciClone** tool. \n\n### Common Issues and Important Notes\n\n- Under the **sciClone** parameters, please specify the correct copy-number caller used to infer the input copy number data, if provided (use the **CNV caller** input for this).\n- **Fishplot** and **Clonevol** currently in rare occasions might not output any plots, if very few mutations are available during the **sciClone** clustering process.\n- A GTF file and a known cancer database (like COSMIC) are optional inputs, as they are used for generating additional plots by the **ClonEvol tool**.\n- If providing multiple file types to the workflow (VCF, BAM, CNV files), make sure that the naming of chromosomes is compatibles across the files (i.e. >1, >2, ... or >chr1, >chr2, ...). \n- VCF files usually have different formats inside of them. Therefore, instead of the user specifying the type of VCF file they use, the workflow will try and recognize the variant caller from which the VCF came. If the caller is not recognized, and unknown caller error will be returned. The current list of supported callers includes: Mutect1, Mutect2, Varscan, Vardict, Sentieon TNsnv, Muse, Strelka1, Strelka2, GATK Haplotype Caller, Sentien Haplotyper, Sentieon TNscope, EBcall.\n- Similar goes for CNV files - the workflow will automatically try to infer from which CNV caller your CNV results came, and properly parse so that sciClone has no issues in successfully using the file. The currently supported list of CNV callers includes: CNVkit, ControlFREEC, PureCN, Facets, Sequenza, ICR96, GATK, SBG-Conseca.  \n\n### Performance Benchmarking\n\nThe workflow is not computationally challenging, being that it starts from VCF files, so all tasks finish successfully on the default instance, which is c4.2xlarge (AWS), with no problems, and pretty much in the same time range (6-7 minutes), and costing around $0.10 using on-demand instances. \n\n*Cost can be significantly reduced by **spot instance** usage. Visit [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*\n\n### API Python Implementation\nThe workflow's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for corresponding platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).\n\n```python\nfrom sevenbridges import Api\n\n# Enter api credentials\nauthentication_token, api_endpoint = \"enter_your_token\", \"enter_api_endpoint\"\napi = Api(token=authentication_token, url=api_endpoint)\n\n# Get project_id/workflow_id from your address bar. Example: https://igor.sbgenomics.com/u/your_username/project/workflow\nproject_id, workflow_id = \"your_username/project\", \"your_username/project/workflow\"\n\n# Get file names from files in your project. File names below are just as an example.\ninputs = {\n        'copyNumberCalls': list(api.files.query(project=project_id, names=['copy_number_results.txt'])),\n        'input_files': list(api.files.query(project=project_id, names=['somatic_mutations.vcf'])),\n        'cnv_caller': 'CNVkit'\n        }\n\n# Run the task\ntask = api.tasks.create(name='TH workflow - API Example', project=project_id, app=workflow_id, inputs=inputs, run=True)\n```\nInstructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).\n\nAdditionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).\n\n### References\n\n[1] [sciClone paper](http://journals.plos.org/ploscompbiol/article/asset?id=10.1371%2Fjournal.pcbi.1003665.PDF)",
  "hints": [
    {
      "value": "c4.2xlarge;ebs-gp2;200",
      "class": "sbg:AWSInstanceType"
    },
    {
      "class": "sbg:AlibabaCloudInstanceType",
      "value": "ecs.c5.2xlarge;cloud_ssd;200"
    },
    {
      "class": "sbg:GoogleInstanceType",
      "value": "n1-standard-32;pd-ssd;200"
    }
  ],
  "cwlVersion": "sbg:draft-2",
  "$namespaces": {
    "sbg": "https://sevenbridges.com"
  },
  "sbg:appVersion": [
    "sbg:draft-2"
  ],
  "id": "https://api.sbgenomics.com/v2/apps/uros_sipetic/bms-tumor-heterogeneity-dev/sciclone-workflow/224/raw/",
  "sbg:id": "uros_sipetic/bms-tumor-heterogeneity-dev/sciclone-workflow/224",
  "sbg:revision": 224,
  "sbg:revisionNotes": "Update VCFtools Subset",
  "sbg:modifiedOn": 1566296640,
  "sbg:modifiedBy": "uros_sipetic",
  "sbg:createdOn": 1481651071,
  "sbg:createdBy": "uros_sipetic",
  "sbg:project": "uros_sipetic/bms-tumor-heterogeneity-dev",
  "sbg:sbgMaintained": false,
  "sbg:validationErrors": [],
  "sbg:contributors": [
    "uros_sipetic",
    "aleksandar.mihajlovic",
    "anamijalkovic"
  ],
  "sbg:latestRevision": 224,
  "sbg:publisher": "sbg",
  "sbg:content_hash": "adbc8c77f24ebf7ed18e843968052cb51c0cf9d6e460b8f958dac289f1809f22e"
}
