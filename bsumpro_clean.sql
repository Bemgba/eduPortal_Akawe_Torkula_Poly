

-- ----------------------------
-- Table structure for Subtabs
-- ----------------------------
--  `Subtabs`;
CREATE TABLE `Subtabs` (
  `subtabid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `subtabname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `pageid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `tabid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `status` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `comment` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`subtabid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Supplementarybiodataform
-- ----------------------------
--  `Supplementarybiodataform`;
CREATE TABLE `Supplementarybiodataform` (
  `regno` varchar(250) NOT NULL,
  `parentannualincome` varchar(250) NOT NULL,
  `parentprofession` varchar(250) NOT NULL,
  `primaryschoolfees` varchar(250) NOT NULL,
  `primaryschoolname` varchar(250) NOT NULL,
  `secondaryschoolfees` varchar(250) NOT NULL,
  `secondaryschoolname` varchar(250) NOT NULL,
  `parentemail` varchar(255) DEFAULT NULL,
  `parentphone` varchar(255) DEFAULT NULL,
  `placeofbirth` varchar(255) DEFAULT NULL,
  `dateoathattested` varchar(255) DEFAULT NULL,
  `oathformattested` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`regno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Supplementarybiodataform_copy
-- ----------------------------


-- ----------------------------
-- Table structure for TABLE 281
-- ----------------------------


-- ----------------------------
-- Table structure for Tabs
-- ----------------------------
--  `Tabs`;
CREATE TABLE `Tabs` (
  `tabid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `tabname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `role` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`tabid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Tmppages
-- ----------------------------
--  `Tmppages`;
CREATE TABLE `Tmppages` (
  `pageid` varchar(255) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `datecreated` varchar(255) DEFAULT NULL,
  `dscription` varchar(255) DEFAULT NULL,
  `pagename` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pageid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Transactionlogs
-- ----------------------------
--  `Transactionlogs`;
CREATE TABLE `Transactionlogs` (
  `txId` varchar(200) NOT NULL,
  `secreteId` varchar(200) DEFAULT NULL,
  `dateOfEntry` varchar(200) DEFAULT NULL,
  `timeofEntry` varchar(200) DEFAULT NULL,
  `entryType` varchar(200) DEFAULT NULL,
  `description` text,
  `entryBy` varchar(200) DEFAULT NULL,
  `pagename` varchar(200) DEFAULT NULL,
  `txip` varchar(200) DEFAULT NULL,
  `txdevice` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`txId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Transcriptapplication
-- ----------------------------
--  `Transcriptapplication`;
CREATE TABLE `Transcriptapplication` (
  `id` varchar(255) NOT NULL,
  `currentfirstname` varchar(250) DEFAULT NULL,
  `currentmiddlename` varchar(100) DEFAULT NULL,
  `currentsurname` varchar(200) DEFAULT NULL,
  `dateapplied` varchar(255) DEFAULT NULL,
  `datemodified` varchar(255) DEFAULT NULL,
  `dob` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `formerfirstname` varchar(250) DEFAULT NULL,
  `formermiddlename` varchar(100) DEFAULT NULL,
  `formersurname` varchar(250) DEFAULT NULL,
  `matno` varchar(200) DEFAULT NULL,
  `orderstatus` varchar(100) DEFAULT NULL,
  `paymentstatus` varchar(50) DEFAULT NULL,
  `phonenumber` varchar(20) DEFAULT NULL,
  `recipientdetails` longtext,
  `country` varchar(255) DEFAULT NULL,
  `programme` varchar(255) DEFAULT NULL,
  `sessions` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Transcriptapplicationhistory
-- ----------------------------
--  `Transcriptapplicationhistory`;
CREATE TABLE `Transcriptapplicationhistory` (
  `id` varchar(255) NOT NULL,
  `datemodified` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `transcriptorderid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Transcripts
-- ----------------------------
--  `Transcripts`;
CREATE TABLE `Transcripts` (
  `regid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `registrationno` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sessions` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `semester` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `coursecode` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `status` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `approvalstatus` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `att` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `ca` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `exam` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `gp` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `creditunit` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `grade` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `carryoverstatus` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `levels` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `batchid` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `coscode` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `matno` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`regid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for Transcriptstatus
-- ----------------------------
--  `Transcriptstatus`;
CREATE TABLE `Transcriptstatus` (
  `id` varchar(255) NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for TwoSittings
-- ----------------------------
--  `TwoSittings`;
CREATE TABLE `TwoSittings` (
  `regno` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for UPLOAD_DE
-- ----------------------------
----------
-- Table structure for UPLOAD_REM
-- ----------------------------
--  `UPLOAD_REM`;


-- ----------------------------
-- Table structure for UPLOAD_REM_copy

-- Table structure for Units
-- ----------------------------
--  `Units`;
CREATE TABLE `Units` (
  `unitcode` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `unitname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `deptcode` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`unitcode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Uploadacceptance
-- ----------------------------


-- ----------------------------
-- Table structure for Userdesktop
-- ----------------------------
--  `Userdesktop`;
CREATE TABLE `Userdesktop` (
  `transid` varchar(200) NOT NULL,
  `username` varchar(200) DEFAULT NULL,
  `datetime` varchar(200) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`transid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Userlog
-- ----------------------------
--  `Userlog`;
CREATE TABLE `Userlog` (
  `logid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `username` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `datelogin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `timelogin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `iplogin` text,
  `browserlogin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`logid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Userprogramme
-- ----------------------------
--  `Userprogramme`;
CREATE TABLE `Userprogramme` (
  `upid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `username` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `programme` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`upid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Userroles
-- ----------------------------
--  `Userroles`;
CREATE TABLE `Userroles` (
  `userroleid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `username` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `rolename` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (`userroleid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Users
-- ----------------------------
--  `Users`;
CREATE TABLE `Users` (
  `username` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `password` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `datelastlogin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `iplastlogin` varchar(500) DEFAULT NULL,
  `timelastlogin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `browserlastlogin` varchar(700) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Utme_scores
-- ----------------------------
--  `Utme_scores`;
CREATE TABLE `Utme_scores` (
  `RegNumb` varchar(255) NOT NULL,
  `PUTME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RegNumb`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Utme_scores_copy
-- ----------------------------
--  `Utme_scores_copy`;


-- ----------------------------
-- Table structure for Utmeapplicants
-- ----------------------------
--  `Utmeapplicants`;
CREATE TABLE `Utmeapplicants` (
  `utmeregno` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `courseofstudy` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sessions` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `lastname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `firstname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `middlename` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT '',
  `sex` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `maritalstatus` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `dateofbirth` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `nationality` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `stateoforigin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `lga` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `phoneno` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `programme` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `engscore` int(11) NOT NULL,
  `subj2` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `subj2score` int(11) NOT NULL,
  `subj3` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `subj3score` int(11) NOT NULL,
  `subj4` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `subj4score` int(11) NOT NULL,
  `utmetscores` int(11) NOT NULL,
  `putmescore` int(11) NOT NULL,
  `admcriteria` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `admstatus` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `batchid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`utmeregno`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



-- ----------------------------
-- Table structure for Utmeapplicants2020_2021
-- ----------------------------
--  `Utmeapplicants2020_2021`;


-- ----------------------------
-- Table structure for Utmeapplicantspassport
-- ----------------------------
--  `Utmeapplicantspassport`;
CREATE TABLE `Utmeapplicantspassport` (
  `id` varchar(200) NOT NULL,
  `passport` mediumblob NOT NULL,
  `passportid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for Utmeapplicantspassport2

-- ----------------------------
-- Table structure for Utmechangeofcourse
-- ----------------------------
--  `Utmechangeofcourse`;
CREATE TABLE `Utmechangeofcourse` (
  `regno` text,
  `full name` text,
  `new_course` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for Utmepassport16thsept2020
-- ----------------------------
--  `Utmepassport16thsept2020`;


-- ----------------------------
-- Table structure for Utmepassports
-- ----------------------------
--  `Utmepassports`;
CREATE TABLE `Utmepassports` (
  `passportid` varchar(255) NOT NULL,
  `passport` longblob,
  `datetimeadded` varchar(45) DEFAULT NULL,
  `addedby` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`passportid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Vcapplicantreferees
-- ----------------------------
--  `Vcapplicantreferees`;
CREATE TABLE `Vcapplicantreferees` (
  `refid` varchar(255) NOT NULL,
  `applicantid` varchar(255) DEFAULT NULL,
  `refemail` varchar(255) DEFAULT NULL,
  `refmobile` varchar(255) DEFAULT NULL,
  `refname` varchar(255) DEFAULT NULL,
  `refpostaladd` varchar(255) DEFAULT NULL,
  `refrank` varchar(255) DEFAULT NULL,
  `document` longblob,
  `dateuploaded` varchar(45) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Vcapplicants
-- ----------------------------
--  `Vcapplicants`;
CREATE TABLE `Vcapplicants` (
  `idvcapplicants` varchar(250) NOT NULL,
  `surname` varchar(250) DEFAULT NULL,
  `othernames` varchar(250) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `dob` varchar(45) DEFAULT NULL,
  `areaofspecialty` varchar(300) DEFAULT NULL,
  `yrsofexperience` varchar(45) DEFAULT NULL,
  `password` varchar(250) DEFAULT NULL,
  `applicationstatus` varchar(45) DEFAULT NULL,
  `dateapplied` varchar(45) DEFAULT NULL,
  `rank` varchar(45) DEFAULT NULL,
  `post` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idvcapplicants`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for Vcapplicantuploads
-- ----------------------------
--  `Vcapplicantuploads`;
CREATE TABLE `Vcapplicantuploads` (
  `txid` varchar(255) NOT NULL,
  `idvcapplicant` varchar(255) DEFAULT NULL,
  `documenttype` varchar(100) DEFAULT NULL,
  `document` longblob,
  `dateuploaded` varchar(45) DEFAULT NULL,
  `filetype` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`txid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for Webpayattempts
-- ----------------------------
--  `Webpayattempts`;
CREATE TABLE `Webpayattempts` (
  `transid` varchar(255) NOT NULL,
  `custipadd` varchar(255) DEFAULT NULL,
  `custref` varchar(255) DEFAULT NULL,
  `dateattempt` varchar(255) DEFAULT NULL,
  `responsestatus` varchar(255) DEFAULT NULL,
  `retref` varchar(255) DEFAULT NULL,
  `timeattempt` varchar(255) DEFAULT NULL,
  `cardno` varchar(200) DEFAULT NULL,
  `amount` varchar(200) DEFAULT NULL,
  `responsedesc` varchar(200) DEFAULT NULL,
  `bankreference` varchar(200) DEFAULT NULL,
  `settlementdate` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`transid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Wspayments
-- ----------------------------
--  `Wspayments`;
CREATE TABLE `Wspayments` (
  `paymentid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `pin` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `amount` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `createddate` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `sessions` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `programme` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `paytype` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `bankcode` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `branchcode` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `bankerid` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `regno` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `fullname` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `course` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `level` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `semester` varchar(250) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `paymentoption` varchar(250) DEFAULT NULL,
  `transactionstatus` varchar(250) DEFAULT NULL,
  `batchid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`paymentid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for admissionlistTST
-- ----------------------------
--  `payments_from_interswitch2`;
CREATE TABLE `Payments_from_interswitch2` (
  `useid` text,
  `bank` text,
  `method` text,
  `Datetimepaid` text,
  `Datepaid` text,
  `recinopay` int(11) DEFAULT NULL,
  `reffno` bigint(20) DEFAULT NULL,
  `pin` bigint(20) DEFAULT NULL,
  `fullname` text,
  `paytype` text,
  `statuss` int(11) DEFAULT NULL,
  `amountpaid` text,
  `PaymentMethod` text,
  `cardno` text,
  `Value Date` text,
  `bankname` text,
  `Info` text,
  `bankcode` text,
  `setlementdate` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

