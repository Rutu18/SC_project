const { expect } = require('chai');

const { BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

const { ZERO_ADDRESS } = constants;

const NFT_ACToken = artifacts.require('NFT_ACToken');

//get address from json file
function getAddress(node_name){
	// Load config data from SmartToken.json
	var addrlist = require('../scripts/addr_list.json');	
	return addrlist[node_name];	
};


contract('NFT_ACToken', function ([ owner, other ]) {
	const name = 'NFT_ACToken';
	const symbol = 'CapAC';

	const firstTokenId = new BN(getAddress('token1')).toString();
	const secondTokenId = new BN(getAddress('token2')).toString();
	const otherTokenId = new BN(getAddress('token3')).toString();
	const nonExistentTokenId = new BN(getAddress('token4')).toString();
	const baseURI = 'https://api.example.com/v1/';

	const RECEIVER_MAGIC_VALUE = '0x150b7a02';

	beforeEach(async function () {
		this.token = await NFT_ACToken.new(name, symbol);
	});

	context('with minted CapAC ', function () {
		beforeEach(async function () {
		  await this.token.mint(owner, firstTokenId);
		  this.cap_ac = await this.token.query_CapAC(firstTokenId)
		});

		describe('mintCapAC', function () {
		  context('when the given token owns CapAC', function () {
		    it('returns the id', async function () {
		      expect(this.cap_ac[0]).to.be.bignumber.equal('1');
		    });
		    it('returns the name', async function () {
		      expect(this.cap_ac[1]).to.be.equal('');
		    });
		    it('returns the gender', async function () {
		      expect(this.cap_ac[2]).to.be.equal('');
		    });
		    // it('returns the authorization', async function () {
		    //   expect(this.cap_ac[3]).to.be.equal('NULL');
		    // });
		  });
		});
	});

	context('with empty CapAC', function () {
		beforeEach(async function () {
		  this.cap_ac = await this.token.query_CapAC(firstTokenId)
		});

		context('when the given token without CapAC', function () {
			it('returns the id', async function () {
			  expect(this.cap_ac[0]).to.be.bignumber.equal('0');
			});
			it('returns the name', async function () {
			  expect(this.cap_ac[1]).to.be.equal('');
			});
			it('returns the gender', async function () {
			  expect(this.cap_ac[2]).to.be.equal('');
			});
			//it('returns the authorization', async function () {
			 // expect(this.cap_ac[3]).to.be.equal('');
			//});
		});
	});

	context('update CapAC', function () {
		beforeEach(async function () {
		  await this.token.mint(owner, firstTokenId);
		});

		describe('setCapAC_gender', function () {
		  context('when the given address owns CapAC', function () {
	          it('verify name and gender', async function () {
	          	await this.token.setCapAC_gender(firstTokenId, 'bob', 'male', { from: owner });
	          	this.cap_ac = await this.token.query_CapAC(firstTokenId);
	          	expect(this.cap_ac[1]).to.be.equal('bob');
	          	expect(this.cap_ac[2]).to.be.equal('male');
	          });
		  });
		  context('when the given address does not own CapAC', function () {
	          it('reverts', async function () {
	            await expectRevert(
	              this.token.setCapAC_gender(firstTokenId, 'bob', 'male', { from: other }),
	              'NFT_ACToken: setCapAC_gender from incorrect owner',
	            );
	          });
		  });
		});

		describe('setCapAC_authorization', function () {
		  context('when the given address owns CapAC', function () {
	          it('verify authorization', async function () {
	          	await this.token.setCapAC_authorization(firstTokenId, 'Assign access rights', { from: owner });
	          	this.cap_ac = await this.token.query_CapAC(firstTokenId);
	          	expect(this.cap_ac[3]).to.be.equal('Assign access rights');
	          });
		  });
		  context('when the given address does not own CapAC', function () {
	          it('reverts', async function () {
	            await expectRevert(
	              this.token.setCapAC_authorization(firstTokenId, 'Assign access rights', { from: other }),
	              'NFT_ACToken: setCapAC_authorization from incorrect owner',
	            );
	          });
		  });
		});

		describe('setDoctorDetails', function () {
		  context('when the given address owns CapAC', function () {
	          it('verify doctor information with valid doctor ID', async function () {
	          	await this.token.setDoctorDetails(firstTokenId, owner, 'Doctor Name 1', 'Prescription 1', { from: owner });
	          	this.doctor = await this.token.getDoctorDetails(firstTokenId,owner);
	          	expect(this.doctor[1]).to.be.equal('Doctor Name 1');
	          	expect(this.doctor[2]).to.be.equal('Prescription 1');
	          });
	          it('verify doctor information without valid doctor ID', async function () {
	          	this.doctor = await this.token.getDoctorDetails(firstTokenId,other);
	          	expect(this.doctor[1]).to.be.equal('');
	          	expect(this.doctor[2]).to.be.equal('');
	          });
		  });
		  context('when the given address does not own CapAC', function () {
	          it('reverts', async function () {
	            await expectRevert(
	              this.token.setDoctorDetails(firstTokenId, owner, 'Doctor Name 1', 'Prescription 1', { from: other }),
	              'NFT_ACToken: setDoctorDetails from incorrect owner',
	            );
	          });
		  });

        describe('setEMRDetails', function () {
		  context('when the given address owns CapAC', function () {
	          it('verify EMR information with valid EMR ID', async function () {
	          	await this.token.setEMRDetails(firstTokenId, owner, 'Patient Name 1', 'AuthInstitutionNames 1', 'Treatment 1', { from: owner });
	          	this.EMR = await this.token.getEMRDetails(firstTokenId,owner);
	          	expect(this.EMR[1]).to.be.equal('Patient Name 1');
	          	expect(this.EMR[2]).to.be.equal('AuthInstitutionNames 1');
	          	expect(this.EMR[3]).to.be.equal('Treatment 1');
	          });

	          it('verify EMR information without valid EMR ID', async function () {
	          	this.EMR = await this.token.getEMRDetails(firstTokenId,other);
	          	expect(this.EMR[1]).to.be.equal('');
	          	expect(this.EMR[2]).to.be.equal('');
	          	expect(this.EMR[3]).to.be.equal('');
	          });
		  });
		  context('when the given address does not own CapAC', function () {
	          it('reverts', async function () {
	            await expectRevert(
	              this.token.setEMRDetails(firstTokenId, owner, 'Patient Name 1', 'AuthInstitutionNames 1', 'Treatment 1', { from: other }),
	              'NFT_ACToken: setEMRDetails from incorrect owner',
	            );
	          });
		  });
		});



		// here is tracker unit test cases
		context('when tracker is default', function () {
			beforeEach(async function () {
				// this.tracker0 = await this.token.query_DataTracker(firstTokenId, 0);
				this.tracker_length = await this.token.total_tracker(firstTokenId);
			});
			it('return length of tracker', async function () {
			  	expect(this.tracker_length).to.be.equal(0);
			});
		});

		describe('NFT_Tracker transfer by owner', function () {
			beforeEach(async function () {
				await this.token.transfer(firstTokenId, owner, other, { from: owner });
				this.tracker_length = await this.token.total_tracker(firstTokenId);
				this.tracker = await this.token.query_DataTracker(firstTokenId, this.tracker_length-1);
			});
			it('return owner address by sender', async function () {
			  	expect(this.tracker[0]).to.be.equal(owner);
			});
			it('return other address by receiver', async function () {
			  	expect(this.tracker[1]).to.be.equal(other);
			});
			it('return length of tracker', async function () {
			  	expect(this.tracker_length).to.be.equal(1);
			});
		});
	});
});
