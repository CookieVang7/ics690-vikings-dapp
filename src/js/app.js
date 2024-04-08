App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasVoted: false,

  init: function() {
    // Initialize Web3
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      window.web3 = new Web3(window.ethereum);
      // Request account access using eth_requestAccounts
      window.ethereum.request({ method: 'eth_requestAccounts' }).then(function(accounts) {
        App.account = accounts[0];
        // Call initContract after getting the account
        return App.initContract();
      }).catch(function(error) {
        // Handle error
        console.error("Error accessing account:", error);
      });
    } else {
      // Fallback to localhost if no web3 instance is detected
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      window.web3 = new Web3(App.web3Provider);
      // Call initContract directly if no account access is needed
      App.initContract();
    }
  },

  initContract: function() {
    $.getJSON("Election2.json", function(election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Election2 = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.Election2.setProvider(App.web3Provider);

      // Listen for events
      App.listenForEvents();

      // Render after contract initialization
      return App.render();
    });

    $.getJSON("SkolFaithful.json", function(skolFaithful) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.SkolFaithful = TruffleContract(skolFaithful);
      // Connect provider to interact with contract
      App.contracts.SkolFaithful.setProvider(App.web3Provider);

      // Render after contract initialization
      return App.renderMember();
    });
  },

  renderMember: function(){
    var skolFaithfulInstance;

    App.contracts.SkolFaithful.deployed().then(function(instance) {
      skolFaithfulInstance = instance;
      return skolFaithfulInstance.skolNation(App.account);
    }).then(function(candidate) {

      $("#mvcAmount").html("MVC  tokens in your account: " + candidate[1]);
      $("#repAmount").html("REP tokens in your account: " + candidate[2]);
      $("#mvcAmount2").html("MVCs in your account: " + candidate[1]);
      //return electionInstance.voters(App.account);
    }).catch(function(error) {
      console.warn(error);
    });
  },

  listenForEvents: function() {
    // Listen for events emitted from the contract
    App.contracts.Election2.deployed().then(function(instance) {
      instance.votedEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        // Reload when a new vote is recorded
        //App.render();
        App.renderMember();
      });
    });
  },

  render: function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    $("#accountAddress").html("Your Account: " + App.account);

    // Load contract data
    App.contracts.Election2.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.candidatesCount();
    }).then(function(candidatesCount) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      var candidatesSelect = $('#candidatesSelect');
      candidatesSelect.empty();

      for (var i = 1; i <= candidatesCount; i++) {
        electionInstance.candidates(i).then(function(candidate) {
          // console.log('CANDIDATE: ' + i);
          // console.log(candidate[0]);
          // console.log(candidate[1]);
          // console.log(candidate[2]);
          // console.log(candidate[3]);
          var id = candidate[0];
          var name = candidate[1];
          var voteCount = candidate[2];

          // Render candidate Result
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          candidatesResults.append(candidateTemplate);

          // Render candidate ballot option
          var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
          candidatesSelect.append(candidateOption);
        });
      }
      return electionInstance.voters(App.account);
    }).then(function(hasVoted) {
      // Do not allow a user to vote more than once
      if(hasVoted) {
        $('form').hide();
      }
      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });

  },

  castVote: function() {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.Election2.deployed().then(function(instance) {
      return instance.vote(candidateId, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
      return App.contracts.Election2.deployed();
    }).then(function(instance) {
      return instance.totalVotes();
    }).then(function(totalVotes) {
      if (totalVotes >=10){
        window.location.href = "results.html";
      }
    })
    .catch(function(err) {
      console.error(err);
    });
  }
  // castVote: function() {
  //   var candidateId = $('#candidatesSelect').val();
  //   App.contracts.Election2.deployed().then(function(instance) {
  //     return instance.vote(candidateId, { from: App.account });
  //   }).then(function(result) {
  //     // Wait for votes to update
  //     $("#content").hide();
  //     $("#loader").show();
  //     return App.contracts.Election2.deployed();
  //   }).then(function(instance) {
  //     return instance.finishVoting();
  //   }).then(function(result) {
  //     return App.contracts.Election2.deployed();
  //   }).then(function(instance) {
  //     return instance.totalVotes();
  //   }).then(function(totalVotes) {
  //     if (totalVotes >=10){
  //       window.location.href = "results.html";
  //     }
  //   })
  //   .catch(function(err) {
  //     console.error(err);
  //   });
  // }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});