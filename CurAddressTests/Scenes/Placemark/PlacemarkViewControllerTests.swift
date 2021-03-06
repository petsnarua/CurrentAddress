//
//  PlacemarkViewControllerTests.swift
//  CurrentAddress
//
//  Created by Raymond Law on 8/3/17.
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CurAddress
import XCTest
import MapKit
import Contacts

// MARK: - Test doubles

class PlacemarkBusinessLogicSpy: PlacemarkBusinessLogic
{
  var showPhysicalAddressCalled = false
  
  func showPhysicalAddress(request: Placemark.ShowPhysicalAddress.Request)
  {
    showPhysicalAddressCalled = true
  }
}

class PlacemarkViewControllerTableViewSpy: UITableView
{
  var reloadSectionsCalled = false
  var reloadSectionsIndexSet: IndexSet?
  
  override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
  {
    reloadSectionsCalled = true
    reloadSectionsIndexSet = sections
  }
}

class PlacemarkViewControllerTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: PlacemarkViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupPlacemarkViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupPlacemarkViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "MainStoryboard", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "PlacemarkViewController") as! PlacemarkViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Tests
  
  // MARK: View lifecycle
  
  func testViewWillAppearShouldShowPhysicalAddress()
  {
    // Given
    let placemarkBusinessLogicSpy = PlacemarkBusinessLogicSpy()
    sut.interactor = placemarkBusinessLogicSpy
    loadView()
    
    // When
    sut.viewWillAppear(true)
    
    // Then
    XCTAssertTrue(placemarkBusinessLogicSpy.showPhysicalAddressCalled, "viewWillAppear() should ask the interactor to show the physical address")
  }
  
  // MARK: Show physical address
  
  func testDisplayShowPhysicalAddressShouldConfigureCells()
  {
    // Given
    let placemarkBusinessLogicSpy = PlacemarkBusinessLogicSpy()
    sut.interactor = placemarkBusinessLogicSpy
    loadView()
    let placemark = CurAddressTestHelpers.placemark
    let viewModel = Placemark.ShowPhysicalAddress.ViewModel(placemark: placemark)
    
    // When
    sut.displayShowPhysicalAddress(viewModel: viewModel)
    
    // Then
    var cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.thoroughfare, "displayShowPhysicalAddress() should set the 1st cell to the thoroughfare")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.subThoroughfare, "displayShowPhysicalAddress() should set the 2nd cell to the subThoroughfare")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 2, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.locality, "displayShowPhysicalAddress() should set the 3rd cell to the locality")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 3, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.subLocality, "displayShowPhysicalAddress() should set the 4th cell to the subLocality")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 4, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.administrativeArea, "displayShowPhysicalAddress() should set the 5th cell to the administrativeArea")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 5, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.subAdministrativeArea, "displayShowPhysicalAddress() should set the 6th cell to the subAdministrativeArea")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 6, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.postalCode, "displayShowPhysicalAddress() should set the 7th cell to the postalCode")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 7, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.country, "displayShowPhysicalAddress() should set the 8th cell to the country")
    
    cell = sut.tableView.cellForRow(at: IndexPath(row: 8, section: 0))!
    XCTAssertEqual(cell.detailTextLabel?.text, placemark.isoCountryCode, "displayShowPhysicalAddress() should set the 9th cell to the isoCountryCode")
  }
  
  func testDisplayShowPhysicalAddressShouldReloadTableView()
  {
    // Given
    let placemarkBusinessLogicSpy = PlacemarkBusinessLogicSpy()
    sut.interactor = placemarkBusinessLogicSpy
    loadView()
    let placemarkViewControllerTableViewSpy = PlacemarkViewControllerTableViewSpy()
    sut.tableView = placemarkViewControllerTableViewSpy
    let placemark = CurAddressTestHelpers.placemark
    let viewModel = Placemark.ShowPhysicalAddress.ViewModel(placemark: placemark)
    
    // When
    sut.displayShowPhysicalAddress(viewModel: viewModel)
    
    // Then
    XCTAssertTrue(placemarkViewControllerTableViewSpy.reloadSectionsCalled, "displayShowPhysicalAddress() should ask the table view to reload its sections")
    XCTAssertEqual(placemarkViewControllerTableViewSpy.reloadSectionsIndexSet, IndexSet(integer: 0), "displayShowPhysicalAddress() should ask the table view to reload the first section")
  }
}
