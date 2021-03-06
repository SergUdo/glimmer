require 'spec_helper'
require 'glimmer/data_binding/observer'
require 'glimmer/data_binding/observable_model'

describe Glimmer::DataBinding::ObservableModel do
  before :all do
    class Task
      attr_accessor :name, :subtasks
      
      class << self
        attr_accessor :name_filter
      end
    end
  end
  
  after :all do
    Object.send(:remove_const, :Task) if Object.const_defined?(:Task)
  end
  
  context 'object (instance)' do
    it 'adds observer' do
      task = Task.new
      @observer_called = nil
      Glimmer::DataBinding::Observer.proc do |new_value|
        @observer_called = new_value
      end.observe(task, :name)
      task.name = 'Sean'
      expect(@observer_called).to eq('Sean')
    end
    
    it 'adds observer to array property' do
      task = Task.new
      task.name = 'Sean'
      task.subtasks = ['subtask1', 'subtask2']
      @observer_called = nil
      Glimmer::DataBinding::Observer.proc do |new_value|
        @observer_called = new_value
      end.observe(task, :subtasks)
      task.subtasks << 'subtask3'
      expect(@observer_called).to eq(['subtask1', 'subtask2', 'subtask3'])
    end
    
    it 'removes observer' do
      task = Task.new
      observer = Glimmer::DataBinding::Observer.proc do |new_value|
        @observer_called = new_value
      end
      observer.observe(task, :name)
      observer.unobserve(task, :name)
      task.name = 'Sean'
      expect(@observer_called).to be_nil
    end
    
    it 'checks if object has observer for any property' do
      task = Task.new
      @observer_called = nil
      observer = Glimmer::DataBinding::Observer.proc do |new_value|
        @observer_called = new_value
      end
      observer.observe(task, :name)
      expect(task.has_observer_for_any_property?(observer)).to eq(true)
      observer.unobserve(task, :name)
      expect(task.has_observer_for_any_property?(observer)).to eq(false)
    end
  end
  
  context 'class' do
    it 'adds observer' do
      Glimmer::DataBinding::Observer.proc do |new_value|
        @observer_called = new_value
      end.observe(Task, :name_filter)
      Task.name_filter = 'Se'
      expect(@observer_called).to eq('Se')
    end  
  end
end
