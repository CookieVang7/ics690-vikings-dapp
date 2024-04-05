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
      $.getJSON("CoachVotingMechanism.json", function(coachVote) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.CoachVotingMechanism = TruffleContract(coachVote);
        // Connect provider to interact with contract
        App.contracts.CoachVotingMechanism.setProvider(App.web3Provider);
  
        // Listen for events
        App.listenForEvents();
  
        // Render after contract initialization
        return App.render();
      });
    },
  
    listenForEvents: function() {
      // Listen for events emitted from the contract
      App.contracts.CoachVotingMechanism.deployed().then(function(instance) {
        instance.votedEvent({}, {
          fromBlock: 0,
          toBlock: 'latest'
        }).watch(function(error, event) {
          // Reload when a new vote is recorded
          App.render();
        });
      });
    },
  
    render: function() {
      var electionInstance;
      var coachVotingMechanismInstance;
      var loader = $("#loader");
      var content = $("#content");
  
      loader.hide();
      content.show();
  
      $("#accountAddress").html("Your Account: " + App.account);
  
  
      // Load contract data
      App.contracts.CoachVotingMechanism.deployed().then(function(instance) {
        coachVotingMechanismInstance = instance;
        return coachVotingMechanismInstance.candidateCount();
      }).then(function(candidateCount) {
        var candidatesResults = $("#candidatesResults");
        candidatesResults.empty();
  
        var candidatesSelect = $('#candidatesSelect');
        candidatesSelect.empty();
  
        for (var i = 1; i <= candidateCount; i++) {
          coachVotingMechanismInstance.candidates(i).then(function(candidate) {
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
        return coachVotingMechanismInstance.haveVoted(App.account);
      }).then(function(hasVoted) {
        // Do not allow a user to vote
        console.log('YAY');
        console.log(hasVoted);
        if(hasVoted) {
          console.log('NAY');
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
      App.contracts.CoachVotingMechanism.deployed().then(function(instance) {
        return instance.voteForCandidate(candidateId, App.account, { from: App.account });
      }).then(function(result) {
        // Wait for votes to update
        $("#content").hide();
        $("#loader").show();
      }).catch(function(err) {
        console.error(err);
      });
    }
  };
  
  $(function() {
    $(window).load(function() {
      App.init();
    });
  });