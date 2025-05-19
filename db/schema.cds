using {
  Currency,
  managed,
  cuid,
  sap.common.CodeList
} from '@sap/cds/common';

namespace sap.capire.bookshop;

entity Books : managed, cuid {
  @mandatory title  : localized String(111);
  descr             : localized String(1111);
  @mandatory author : Association to Authors;
  genre             : Association to Genres;
  stock             : Integer;
  price             : Decimal;
  currency          : Currency;
  image             : LargeBinary @Core.MediaType: 'image/png';
}

entity Authors : managed, cuid {
  @mandatory name : String(111);
  dateOfBirth     : Date;
  dateOfDeath     : Date;
  placeOfBirth    : String;
  placeOfDeath    : String;
  books           : Association to many Books
                      on books.author = $self;
}

/** Hierarchically organized Code List for Genres */
entity Genres : CodeList {
  key ID       : Integer;
      parent   : Association to Genres;
      children : Composition of many Genres
                   on children.parent = $self;
}

entity Substancies : cuid, managed{
  calculation       : Association to one Configurations;
  compositionItem   : Association to one Items;
  compositionItemGroup : Association to many ItemGroups on compositionItemGroup.itemID = compositionItem.ID;
}

@cds.persistence.exists
entity AdminService_Substancies_drafts : cuid, managed, DraftEnabledEntity{
  calculation       : Association to one Configurations;
  compositionItem   : Association to one Items;
  compositionItemGroup : Association to many ItemGroups_DraftEnabled on compositionItemGroup.itemID = compositionItem.ID;

}
// annotate AdminService_Substancies_drafts with @cds.persistence.exists: false;

entity Configurations : cuid, managed{
  displayId     : String(30);
  name          : String(100);
}

view ItemGroups as
    select from ItemGroupAssignment as assignment
    inner join Items as item on assignment.compositionItem.ID = item.ID
    inner join Groups as itemGroup on assignment.compositionGroup.ID = itemGroup.ID{
      key item.ID as itemID,
      key itemGroup.ID as groupID,
          itemGroup.displayId as displayID,
          itemGroup.status_code as status_code
    }

// New draft-enabled view that includes draft fields
// This will be used by draft-enabled entities
view ItemGroups_DraftEnabled as
    select from ItemGroupAssignment as assignment
    inner join Items as item on assignment.compositionItem.ID = item.ID
    inner join Groups as itemGroup on assignment.compositionGroup.ID = itemGroup.ID {
      key item.ID as itemID,
      key itemGroup.ID as groupID,
      itemGroup.displayId as displayID,
      itemGroup.status_code as status_code
    }

entity ItemGroupAssignment : cuid{
    compositionItem   : Association to Items;
    compositionGroup  : Association to Groups;
}

entity Items : cuid {
    displayId : String(30);
    name      : String(30);
}
entity Groups : cuid {
    displayId : String(30);
    status_code : String(30);
}
aspect DraftEnabledEntity {
    IsActiveEntity : Boolean;
    HasActiveEntity : Boolean;
    HasDraftEntity  : Boolean;
}