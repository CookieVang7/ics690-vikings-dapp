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
  
        return App.results();
      });
  
      $.getJSON("SkolFaithful.json", function(skolFaithful) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.SkolFaithful = TruffleContract(skolFaithful);
        // Connect provider to interact with contract
        App.contracts.SkolFaithful.setProvider(App.web3Provider);
  
        return App.results();
      });
    },
  
    results: function() {
      $("#accountAddress2").html("Your Account: " + App.account);
      App.contracts.SkolFaithful.deployed().then(function(instance) {
        skolFaithfulInstance = instance;
        return skolFaithfulInstance.skolNation(App.account);
      }).then(function(candidate) {
  
        $("#mvcAmount2").html("MVCs in your account: " + candidate[1]);
      })
  
      var loader = $("#loader");
      var content = $("#content");
      var results = $("#results");
  
      loader.hide();
      content.hide();
      results.show();
      
    },

  };
  
  $(function() {
    $(window).load(function() {
      App.init();
    });
  });