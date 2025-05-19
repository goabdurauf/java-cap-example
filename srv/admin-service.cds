using {sap.capire.bookshop as my} from '../db/schema';

service AdminService {
  entity Books   as projection on my.Books;
  entity Authors as projection on my.Authors;
  entity Substancies as projection on my.Substancies;
  entity Items as projection on my.Items;
  entity Groups as projection on my.Groups;
  entity ItemGroups as projection on my.ItemGroups;
//   entity ItemGroups_draft as projection on my.ItemGroups_DraftEnabled;
  entity Configuration as projection on my.Configurations;
//   @cds.persistence.exists
//     entity Substancies_drafts as projection on my.AdminService_Substancies_drafts;
}
