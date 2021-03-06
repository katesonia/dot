App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    console.log('init');
    $.getJSON('../members.json', function(data) {
      // App.setTokenAmount(data.balance);
      // App.setName(data.name);
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('RandomMembers.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var RandomMembersArtifact = data;
      App.contracts.RandomMembers = TruffleContract(RandomMembersArtifact);

      // Set the provider for our contract
      App.contracts.RandomMembers.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.getName();
    }).then( function() {
      $.getJSON('DotToken.json', function(data) {
        // Get the necessary contract artifact file and instantiate it with truffle-contract
        var DotTokenArtifact = data;
        App.contracts.DotToken = TruffleContract(DotTokenArtifact);

        // Set the provider for our contract
        App.contracts.DotToken.setProvider(App.web3Provider);

        // Use our contract to retrieve and mark the adopted pets
        return App.getBalance();
      });
    })  ;


    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.transfer-submit-btn', App.rewardOtherMember);
    // $(document).on('click', '.voted-yes-btn', App.handleVotedYes);
    // $(document).on('click', '.proposal-submit-btn', App.handleProposalSubmission);
  },

  handleProposalSubmission: function() {
    var name = $('#proposal-name')[0].innerText;
    var tokenNeeded = $('#token-needed')[0].innerText;
    var voteProposalInstance;
    App.contracts.VoteProposal.deployed().then(function(instance) {
        voteProposalInstance = instance;
        voteProposalInstance.propose(Number(tokenNeeded)).then(function(res) {
            console.log(res);
        }).catch(function(err){
            console.log('voteProposalInstance.propose returned error: ' + JSON.stringify(err));
        })
    }).catch(function(err) {
        console.log('VoteProposal deploy error: ' + err.message);
   });
  },
  
  rewardOtherMember: function() {
    var address = document.getElementById('reward-address').value;
    var tokens = document.getElementById('reward-tokens').value;
    var reason = document.getElementById('reward-reason').value;
    var dotTokenInstance;
    App.contracts.DotToken.deployed().then(function(instance) {
        dotTokenInstance = instance;
        dotTokenInstance.rewardMember(address, tokens, reason).then(function(res) {
            console.log(res);
        }).catch(function(err){
            console.log('dotTokenInstance.rewardMember returned error: ' + JSON.stringify(err));
        })
    }).catch(function(err) {
        console.log('DotToken deploy error: ' + err.message);
  });
  },

  getBalance: function() {
    var account;
      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }

        account = accounts[0];
        console.log(accounts);
      });


    var dotTokenInstance;


    App.contracts.DotToken.deployed().then(function(instance) {
      dotTokenInstance = instance;

      var amount = dotTokenInstance.balanceOf.call(account);
      console.log(amount);
      return amount;
    }).then(function(amount) {
      console.log('got amount' + amount);
      App.setTokenAmount(Number(amount));
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  getName: function() {
    var account;
      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }

        account = accounts[0];
        console.log(accounts);
      });
    var randomMembersInstance;


    App.contracts.RandomMembers.deployed().then(function(instance) {
      randomMembersInstance = instance;

      return randomMembersInstance.getMemberInfo.call(account);
    }).then(function(memberInfo) {
      console.log(memberInfo);
      App.setName(memberInfo[1]);
      App.setMemberType(memberInfo[2]);
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  setTokenAmount: function(amount) {
    $('#token-amount')[0].innerText = amount.toLocaleString();
  },

  setName: function(name) {
    $('#member-name')[0].innerText = name;
  },

  setMemberType: function(isBoard) {
    $('#member-type')[0].innerText = isBoard ? 'Board Member' : 'Member';
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
